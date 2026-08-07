# README – Jenkins Pipeline Challenge

## Overview

This submission includes:

- Jenkinsfile — Declarative Pipeline (Groovy)
- monitor_npp.sh — Helper Bash script
- README.md — This document

----

## Goal

Automate the monitoring of a new release of Notepad++ Portable, following the lock file logic and notification workflow defined in the challenge brief.

----

## Architecture and Flow

1. Pipeline execution:

The Jenkins job runs the Jenkinsfile on a Linux agent.

2. Monitoring script (monitor_npp.sh):

Handles the complete logic flow:

If the lock file exists:

- Checks its age.
- If the lock is ≥ 15 days old, downloads both the latest and previous versions, extracts, compares (using diff -ru) and sends an email with the detected changes.
- If the lock is < 15 days old, it exits without action.

If no lock file exists:

- Downloads the “previous” and “latest” archives.
- Compares by sha256 hash, then performs a directory-level diff -ru.

If differences exist:

- Creates a new lock file (timestamp + hashes).
- Sends an alert email notifying that a detailed diff will be sent after 15 days.
- Saves the latest version as a Jenkins artifact (latest_npp.zip).

If no differences are found, exits cleanly.

3. Cleanup:

Temporary files are removed automatically via trap cleanup EXIT in the script and the post section of the Jenkinsfile.

----

## Key Design Decisions & Assumptions

- The Jenkins agent runs on Linux with these available tools: curl, unzip or 7z, diff, mailx, sha256sum, stat.

- The “previous archive” can be either:

A local file in the Jenkins workspace (e.g., previous_notepadpp.zip) or
A URL (to download the literal previous version, as the challenge specifies).

- curl is used with retry and timeout options for robust downloads.
- Archive comparison uses a two-step check: 
a. sha256sum for quick equality check.
b. diff -ru on extracted contents for file-level differences.

- The lock file ensures idempotence, preventing repeated alerts.
It stores the timestamp and both previous/latest hashes.

- On first detection of a new version (no lock present), the script:

Creates the lock file.
Sends an alert email informing that a full diff report will follow in 15 days.
Exits successfully.

- If mailx is not available, the email body is printed to the console and saved as mail_body.txt.

----

## Running Locally (Without Jenkins)

1. Place both monitor_npp.sh and your previous Notepad++ archive (e.g. previous_notepadpp.zip) in the same folder.

2. Run:
```bash
./monitor_npp.sh \
    --download-url "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest/download/npp.7z" \
    --previous-archive "./previous_notepadpp.zip" \
    --lock-file "./npp_update.lock" \
    --email-to "you@domain.com" \
    --tmpdir "./tmp_npp"

```

3. Check:

- monitor_output.log for results.
- latest_npp.zip for the downloaded file.
- mail_body.txt for simulated email content (if mailx unavailable).

----

## Integrating in Jenkins

- Create a new Pipeline job and point it to your repo containing the Jenkinsfile.
- Ensure the Linux agent has the required tools and outbound internet access.
- Optional environment variables (can be overridden via parameters):

NPP_DOWNLOAD_URL

PREVIOUS_ARCHIVE

LOCK_FILE

EMAIL_TO

----

## Testing and Validation

- The pipeline is idempotent — multiple consecutive runs will not trigger duplicate alerts unless the lock expires.
- Logs are verbose and timestamped (e.g., “Lock found”, “Hash changed”, “Email sent”).
- You can simulate the full flow by preparing two different ZIP files locally and running the script twice:
a. First run: detects version change → creates lock + sends initial alert.
b. After manually modifying the lock’s timestamp to 15 days ago → re-run → sends diff email.

----

## Possible Enhancements

- Integrate Jenkins’ Email Extension plugin using credentials from the Jenkins Credential Store.
- Store lock files or previous versions in a shared NFS path or cloud storage bucket.
- Automatically upload the latest archive to artifact storage.
- Add a --force-diff flag for manual testing/debugging.

----

## Conclusion

This solution prioritizes:

- Pipeline logic clarity
- Robustness and reusability
- Clear logging and self-cleaning
- Minimal dependencies