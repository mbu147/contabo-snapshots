#!/bin/sh
set -e

SNAPSHOT_NAME="${SNAPSHOT_NAME:-daily}"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

log "Starting snapshot job (name: ${SNAPSHOT_NAME})"

if ! cntb get instances > /dev/null 2>&1; then
    log "ERROR: Cannot reach Contabo API"
    exit 1
fi

INSTANCES=$(cntb get instances -o json | jq -r '.[].instanceId')

if [ -z "${INSTANCES}" ]; then
    log "No instances found"
    exit 0
fi

for INSTANCE in ${INSTANCES}; do
    # delete all existing snapshots with this name
    cntb get snapshots "${INSTANCE}" -o json --name "${SNAPSHOT_NAME}" \
        | jq -r '.[].snapshotId' \
        | while read -r SNAPSHOT_ID; do
            log "Deleting old '${SNAPSHOT_NAME}' snapshot (${SNAPSHOT_ID}) for instance ${INSTANCE}"
            cntb delete snapshot "${INSTANCE}" "${SNAPSHOT_ID}"
            sleep 5
        done

    log "Creating '${SNAPSHOT_NAME}' snapshot for instance ${INSTANCE}"
    if ! cntb create snapshot "${INSTANCE}" --name "${SNAPSHOT_NAME}"; then
        log "ERROR: Failed to create snapshot for instance ${INSTANCE}"
        exit 1
    fi
done

log "Snapshot job finished"
