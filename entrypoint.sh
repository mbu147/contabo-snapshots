#!/bin/sh
set -e

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# validate required credentials
for VAR in CLIENTID CLIENTSECRET USER PASSWORD; do
    eval "val=\$$VAR"
    if [ -z "${val}" ]; then
        log "ERROR: Required environment variable ${VAR} is not set"
        exit 1
    fi
done

# authenticate
log "Configuring Contabo credentials"
cntb config set-credentials \
    --oauth2-clientid="${CLIENTID}" \
    --oauth2-client-secret="${CLIENTSECRET}" \
    --oauth2-user="${USER}" \
    --oauth2-password="${PASSWORD}"

if [ -n "${CRON_SCHEDULE}" ]; then
    log "Scheduled mode: '${CRON_SCHEDULE}'"
    # redirect cron job output to PID 1 stdout/stderr so it appears in docker logs
    echo "${CRON_SCHEDULE} /snapshot.sh >> /proc/1/fd/1 2>&1" > /etc/crontabs/root
    exec crond -f -l 5
else
    log "One-shot mode"
    exec /snapshot.sh
fi
