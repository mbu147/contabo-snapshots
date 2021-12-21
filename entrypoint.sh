#!/bin/sh

# authenticate
cntb config set-credentials --oauth2-clientid="${CLIENTID}" --oauth2-client-secret="${CLIENTSECRET}" --oauth2-user="${USER}" --oauth2-password="${PASSWORD}"

# get instance id's
INSTANCES=$(cntb get instances -o json |jq -r '.[].instanceId')

for INSTANCE in ${INSTANCES};
do
    # check if old snapshot exist
    if [ "$(cntb get snapshots "${INSTANCE}" -o json --name "daily" |jq -r '.[].snapshotId')" ]; then
        # delete if exist
        echo "delete old 'daily' snapshot for ${INSTANCE}"
        cntb delete snapshot "${INSTANCE}" "$(cntb get snapshots "${INSTANCE}" -o json --name "daily" |jq -r '.[].snapshotId')"
        sleep 5
    fi
    # create new snapshot
    echo "creating snapshot for ${INSTANCE}"
    cntb create snapshot "${INSTANCE}" --name daily
done

