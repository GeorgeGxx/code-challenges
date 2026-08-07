#!/usr/bin/env bash
set -euo pipefail

# ==========================================================
#  monitor_npp.sh
#  Automated monitor for Notepad++ Portable releases
#  Made by @GeorgeGxx
# ==========================================================
#
# Usage:
#   ./monitor_npp.sh --download-url URL --previous-archive path_or_url \
#                    --lock-file LOCK --email-to addr --tmpdir /path/tmp
#
# Assumptions:
#   - Linux agent with: curl, unzip (or 7z), diff, mailx, sha256sum, stat, date
#   - "previous archive" can be a local file or remote URL
#   - Designed to run both locally and in Jenkins
# ==========================================================

# Defaults
DOWNLOAD_URL=""
PREV_ARCHIVE=""
LOCK_FILE="npp_update.lock"
EMAIL_TO=""
TMPDIR="./tmp_npp_monitor"
RETRY_COUNT=5
RETRY_DELAY=5
CURL_TIMEOUT=300     # seconds per transfer
LOCK_AGE_DAYS_THRESHOLD=15

# --- Helpers ---
log() { echo "$(date -Is) [monitor] $*"; }
err() { echo "$(date -Is) [monitor][ERROR] $*" >&2; }

usage() {
  cat <<EOF
Usage:
  $0 --download-url URL --previous-archive path_or_url --lock-file LOCK --email-to addr --tmpdir /path/tmp
EOF
  exit 1
}

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --download-url) DOWNLOAD_URL="$2"; shift 2;;
    --previous-archive) PREV_ARCHIVE="$2"; shift 2;;
    --lock-file) LOCK_FILE="$2"; shift 2;;
    --email-to) EMAIL_TO="$2"; shift 2;;
    --tmpdir) TMPDIR="$2"; shift 2;;
    *) err "Unknown arg: $1"; usage;;
  esac
done

# --- Attribution banner ---
echo "=============================================="
echo "  Notepad++ Portable Monitor Script"
echo "  Made by @GeorgeGxx"
echo "=============================================="
echo

# --- Load .env if present ---
if [[ -f ".env" ]]; then
  log "Loading environment variables from .env"
  export $(grep -v '^#' .env | xargs)
fi

# --- Validate inputs ---
if [[ -z "$DOWNLOAD_URL" || -z "$PREV_ARCHIVE" || -z "$EMAIL_TO" ]]; then
  err "Missing required parameters."
  usage
fi

mkdir -p "$TMPDIR"
cd "$TMPDIR"

cleanup() {
  log "Cleaning temporary files..."
  rm -rf "${TMPDIR:?}/downloaded.*" "${TMPDIR:?}/extracted_new" "${TMPDIR:?}/extracted_prev" \
         latest_npp.zip prev_archive.zip diff_output.txt monitor_output.log || true
}
trap cleanup EXIT

# --- Helper functions ---
download_to() {
  local url="$1"; local out="$2"
  log "Downloading $url -> $out (retries=${RETRY_COUNT}, timeout=${CURL_TIMEOUT})"
  curl --fail --location --retry ${RETRY_COUNT} --retry-delay ${RETRY_DELAY} \
       --max-time ${CURL_TIMEOUT} -o "$out" "$url"
}

extract_archive() {
  local archive="$1"; local dir="$2"
  mkdir -p "$dir"
  if command -v unzip >/dev/null 2>&1 && unzip -t "$archive" >/dev/null 2>&1; then
    log "Using unzip to extract $archive"
    unzip -q "$archive" -d "$dir"
    return 0
  elif command -v 7z >/dev/null 2>&1; then
    log "Using 7z to extract $archive"
    7z x -y -o"$dir" "$archive" >/dev/null
    return 0
  else
    err "No extractor found (unzip or 7z)."
    return 1
  fi
}

sha256_of() { sha256sum "$1" | awk '{print $1}'; }

# ==========================================================
#                      MAIN LOGIC
# ==========================================================

if [[ -f "$LOCK_FILE" ]]; then
  log "Lock found at $LOCK_FILE"
  lock_mtime=$(stat -c %Y "$LOCK_FILE")
  now=$(date +%s)
  age_days=$(( (now - lock_mtime) / 86400 ))
  log "Lock age: ${age_days} days"

  if (( age_days >= LOCK_AGE_DAYS_THRESHOLD )); then
    log "Lock ≥ ${LOCK_AGE_DAYS_THRESHOLD} days → diff and email."

    prev_local="prev_archive.zip"
    if [[ "$PREV_ARCHIVE" =~ ^https?:// ]]; then
      download_to "$PREV_ARCHIVE" "$prev_local"
    else
      [[ -f "$PREV_ARCHIVE" ]] && cp "$PREV_ARCHIVE" "$prev_local" || { err "Previous archive not found"; exit 2; }
    fi

    latest_local="latest_npp.zip"
    download_to "$DOWNLOAD_URL" "$latest_local"

    extract_archive "$prev_local" "extracted_prev"
    extract_archive "$latest_local" "extracted_new"

    diff_output="diff_output.txt"
    log "Running diff -ru extracted_prev extracted_new"
    if diff -ru extracted_prev extracted_new > "$diff_output"; then
      log "No differences found."
      echo "No differences found (lock age check)" > monitor_output.log
      exit 0
    else
      log "Differences found — preparing email."
      subject="Notepad++ Portable: changes detected (lock ≥ ${LOCK_AGE_DAYS_THRESHOLD} days)"
      {
        echo "Differences detected between previous and latest Notepad++ Portable archives."
        echo
        echo "Lock file: $(realpath "$LOCK_FILE")"
        echo "Lock age: ${age_days} days"
        echo
        echo "----------------------------"
        cat "$diff_output"
      } > mail_body.txt

      if command -v mailx >/dev/null 2>&1; then
        cat mail_body.txt | mailx -s "$subject" "$EMAIL_TO"
        log "Email sent to ${EMAIL_TO}"
      else
        err "mailx not found — printing email body:"
        cat mail_body.txt
      fi
      exit 0
    fi
  else
    log "Lock younger than ${LOCK_AGE_DAYS_THRESHOLD} days → no action."
    echo "Lock recent (${age_days} days) — no action." > monitor_output.log
    exit 0
  fi

else
  log "No lock file present → comparing previous vs latest."
  prev_local="prev_archive.zip"

  if [[ "$PREV_ARCHIVE" =~ ^https?:// ]]; then
    log "Previous archive is URL → downloading."
    download_to "$PREV_ARCHIVE" "$prev_local"
  else
    [[ -f "$PREV_ARCHIVE" ]] && cp "$PREV_ARCHIVE" "$prev_local" || { err "Previous archive not found"; exit 2; }
  fi

  latest_local="latest_npp.zip"
  download_to "$DOWNLOAD_URL" "$latest_local"

  sha_prev=$(sha256_of "$prev_local")
  sha_latest=$(sha256_of "$latest_local")
  log "sha_prev: ${sha_prev}"
  log "sha_latest: ${sha_latest}"

  if [[ "$sha_prev" == "$sha_latest" ]]; then
    log "Hashes identical → no new version."
    echo "No new version (hash match)" > monitor_output.log
    exit 0
  fi

  extract_archive "$prev_local" "extracted_prev"
  extract_archive "$latest_local" "extracted_new"

  diff_output="diff_output.txt"
  if diff -ru extracted_prev extracted_new > "$diff_output"; then
    log "No file-level differences found despite hash change."
    echo "No file-level differences found." > monitor_output.log
    exit 0
  else
    log "Changes detected — creating lock file."
    echo "Notepad++ update detected on $(date -Is)" > "${LOCK_FILE}"
    echo "previous_sha: ${sha_prev}" >> "${LOCK_FILE}"
    echo "latest_sha: ${sha_latest}" >> "${LOCK_FILE}"

    subject="Notepad++ Portable: NEW VERSION DETECTED - follow-up in ${LOCK_AGE_DAYS_THRESHOLD} days"
    {
      echo "A new Notepad++ Portable version was detected."
      echo
      echo "Previous SHA: ${sha_prev}"
      echo "Latest SHA:   ${sha_latest}"
      echo
      echo "Lock file created: $(realpath "${LOCK_FILE}")"
      echo "After ${LOCK_AGE_DAYS_THRESHOLD} days, the pipeline will send the diff email."
      echo
      echo "Immediate diff output:"
      echo "----------------------------"
      cat "$diff_output"
    } > mail_body.txt

    if command -v mailx >/dev/null 2>&1; then
      cat mail_body.txt | mailx -s "$subject" "$EMAIL_TO"
      log "Email alert sent to ${EMAIL_TO}"
    else
      err "mailx not found — printing email body:"
      cat mail_body.txt
    fi

    cp "$latest_local" "${PWD}/latest_npp.zip" || true
    echo "Update detected and lock file created." > monitor_output.log
    exit 0
  fi
fi
