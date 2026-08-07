#!/usr/bin/env bash
set -euo pipefail

# monitor_npp.sh
# Usage:
#   ./monitor_npp.sh --download-url URL --previous-archive path_or_url --lock-file LOCK --email-to addr --tmpdir /path/tmp
#
# Assumptions:
# - Linux agent with: curl, unzip (or 7z), diff, mailx, sha256sum, stat, date
# - previous archive can be a file in workspace or a URL
# - Notepad++ Portable is a zip/7z/portable archive. Script tries unzip, then 7z.

# Defaults
DOWNLOAD_URL=""
PREV_ARCHIVE=""
LOCK_FILE="npp_update.lock"
EMAIL_TO=""
TMPDIR="./tmp_npp_monitor"
RETRY_COUNT=5
RETRY_DELAY=5
CURL_TIMEOUT=300   # seconds per transfer
LOCK_AGE_DAYS_THRESHOLD=15

log() { echo "$(date -Is) [monitor] $*"; }
err() { echo "$(date -Is) [monitor][ERROR] $*" >&2; }

usage() {
  cat <<EOF
Usage:
  $0 --download-url URL --previous-archive path_or_url --lock-file LOCK --email-to addr --tmpdir /path/tmp
EOF
  exit 1
}

# parse args
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

if [[ -z "$DOWNLOAD_URL" || -z "$PREV_ARCHIVE" || -z "$EMAIL_TO" ]]; then
  err "Missing required params"
  usage
fi

# --- Attribution banner ---
echo "=============================================="
echo "  Notepad++ Portable Monitor Script"
echo "  Made by @GeorgeGxx"
echo "=============================================="
echo

mkdir -p "$TMPDIR"
cd "$TMPDIR"

cleanup() {
  log "Cleaning temporary files..."
  rm -rf "${TMPDIR:?}/downloaded.*" "${TMPDIR:?}/extracted_new" "${TMPDIR:?}/extracted_prev" latest_npp.zip prev_npp.* prev_archive.zip monitor_output.log || true
}
trap cleanup EXIT

download_to() {
  local url="$1"; local out="$2"
  log "Downloading $url -> $out (retries=${RETRY_COUNT}, timeout=${CURL_TIMEOUT})"
  # robust curl with retries, fail on HTTP errors, follow redirects
  curl --fail --location --retry ${RETRY_COUNT} --retry-delay ${RETRY_DELAY} --max-time ${CURL_TIMEOUT} -o "$out" "$url"
}

# Helper to extract archive to dir
extract_archive() {
  local archive="$1"; local dir="$2"
  mkdir -p "$dir"
  if command -v unzip >/dev/null 2>&1 && unzip -t "$archive" >/dev/null 2>&1; then
    log "Using unzip to extract $archive to $dir"
    unzip -q "$archive" -d "$dir"
    return 0
  fi
  if command -v 7z >/dev/null 2>&1; then
    log "Using 7z to extract $archive to $dir"
    7z x -y -o"$dir" "$archive" >/dev/null
    return 0
  fi
  err "No extractor found (unzip or 7z). Cannot extract $archive"
  return 1
}

# compute sha256
sha256_of() { sha256sum "$1" | awk '{print $1}'; }

# ---------- Lock logic ----------
if [[ -f "$LOCK_FILE" ]]; then
  log "Lock found at $LOCK_FILE"
  # check age
  lock_mtime=$(stat -c %Y "$LOCK_FILE")
  now=$(date +%s)
  age_days=$(( (now - lock_mtime) / 86400 ))
  log "Lock age: ${age_days} days"

  if (( age_days >= LOCK_AGE_DAYS_THRESHOLD )); then
    log "Lock is >= ${LOCK_AGE_DAYS_THRESHOLD} days -> performing diff against previous version and sending email with changes."

    # ensure we have previous archive locally (if PREV_ARCHIVE is URL, download it)
    prev_local="prev_archive.zip"
    if [[ "$PREV_ARCHIVE" =~ ^https?:// ]]; then
      download_to "$PREV_ARCHIVE" "$prev_local"
    else
      if [[ -f "$PREV_ARCHIVE" ]]; then
        cp "$PREV_ARCHIVE" "$prev_local"
      else
        err "Previous archive not found at $PREV_ARCHIVE"
        exit 2
      fi
    fi

    # Download latest to tmp
    latest_local="latest_npp.zip"
    download_to "$DOWNLOAD_URL" "$latest_local"

    # Extract both
    extract_archive "$prev_local" "extracted_prev"
    extract_archive "$latest_local" "extracted_new"

    # Diff and email
    diff_output="diff_output.txt"
    log "Running diff -ru extracted_prev extracted_new"
    if diff -ru extracted_prev extracted_new > "$diff_output" ; then
      # diff returned 0 -> no differences
      log "No differences found between previous and latest."
      echo "No differences found between prev and latest (lock age check)" > monitor_output.log
      exit 0
    else
      log "Differences found. Preparing email to ${EMAIL_TO}."
      # prepare email body
      subject="Notepad++ Portable: changes detected (lock >= ${LOCK_AGE_DAYS_THRESHOLD} days)"
      {
        echo "Differences detected between previous and latest Notepad++ Portable archive."
        echo
        echo "Lock file: $(realpath "$LOCK_FILE")"
        echo "Lock age (days): ${age_days}"
        echo
        echo "Diff output:"
        echo "----------------------------"
        cat "$diff_output"
      } > mail_body.txt

      # send via mailx (subject on single line)
      if command -v mailx >/dev/null 2>&1; then
        cat mail_body.txt | mailx -s "$subject" "$EMAIL_TO"
        log "Email sent to ${EMAIL_TO}"
      else
        # fallback: print to log if mailx absent
        err "mailx not found — cannot send email. See mail_body.txt"
        cat mail_body.txt
      fi
      exit 0
    fi
  else
    log "Lock is younger than ${LOCK_AGE_DAYS_THRESHOLD} days -> exiting with no action."
    echo "Lock recent (${age_days} days) - no action." > monitor_output.log
    exit 0
  fi
else
  log "No lock file present. Proceeding to download and compare with previous."
  prev_local="prev_archive.zip"

  if [[ "$PREV_ARCHIVE" =~ ^https?:// ]]; then
    log "Previous archive is URL — attempting to download it to ${prev_local}"
    download_to "$PREV_ARCHIVE" "$prev_local"
  else
    if [[ -f "$PREV_ARCHIVE" ]]; then
      log "Found local previous archive at ${PREV_ARCHIVE} — copying"
      cp "$PREV_ARCHIVE" "$prev_local"
    else
      err "Previous archive not found at ${PREV_ARCHIVE}. Exiting with error."
      exit 2
    fi
  fi

  # Download latest
  latest_local="latest_npp.zip"
  download_to "$DOWNLOAD_URL" "$latest_local"

  # Quick check: compare sha256 sums
  sha_prev=$(sha256_of "$prev_local")
  sha_latest=$(sha256_of "$latest_local")
  log "sha_prev: ${sha_prev}"
  log "sha_latest: ${sha_latest}"

  if [[ "$sha_prev" == "$sha_latest" ]]; then
    log "Hashes identical -> no new version. Exiting."
    echo "No new version detected (hash match)" > monitor_output.log
    exit 0
  fi

  # Hashes differ -> further check: extract and diff
  extract_archive "$prev_local" "extracted_prev"
  extract_archive "$latest_local" "extracted_new"

  diff_output="diff_output.txt"
  if diff -ru extracted_prev extracted_new > "$diff_output" ; then
    log "No differences at file-level despite different hashes (rare). No action."
    echo "No file-level differences found." > monitor_output.log
    exit 0
  else
    log "Changes detected between previous and latest."

    # Create lock file to mark that update was observed. Lock contains timestamp and brief info.
    log "Creating lock file at ${LOCK_FILE}"
    echo "Notepad++ update detected on $(date -Is)" > "${LOCK_FILE}"
    echo "previous_sha: ${sha_prev}" >> "${LOCK_FILE}"
    echo "latest_sha: ${sha_latest}" >> "${LOCK_FILE}"

    # Compose mail that alerts there is an update and indicate that a follow-up diff will be sent after ${LOCK_AGE_DAYS_THRESHOLD} days
    subject="Notepad++ Portable: NEW VERSION DETECTED - follow-up in ${LOCK_AGE_DAYS_THRESHOLD} days"
    {
      echo "A new Notepad++ Portable version was detected."
      echo
      echo "Previous SHA: ${sha_prev}"
      echo "Latest  SHA: ${sha_latest}"
      echo
      echo "A lock file has been created at: $(realpath "${LOCK_FILE}")"
      echo "After ${LOCK_AGE_DAYS_THRESHOLD} days the pipeline will run the diff and send the detailed changes."
      echo
      echo "If you want to see the immediate diff, it is attached below:"
      echo "----------------------------"
      cat "$diff_output"
    } > mail_body.txt

    if command -v mailx >/dev/null 2>&1; then
      cat mail_body.txt | mailx -s "$subject" "$EMAIL_TO"
      log "Email alert sent to ${EMAIL_TO}"
    else
      err "mailx not found — cannot send email. See mail_body.txt"
      cat mail_body.txt
    fi

    # save latest archive as artifact for later inspection
    cp "$latest_local" "${PWD}/latest_npp.zip" || true

    echo "Update detected and lock file created." > monitor_output.log
    exit 0
  fi
fi
