#!/bin/sh

# authenticate
cntb config set-credentials --oauth2-clientid="${CLIENTID}" --oauth2-client-secret="${CLIENTSECRET}" --oauth2-user="${USER}" --oauth2-password="${PASSWORD}"

# check connection
if ! cntb get instances; then exit 1; fi

# for instance ids
for INSTANCE in $(cntb get instances -o json |jq -r '.[].instanceId');
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
    if ! cntb create snapshot "${INSTANCE}" --name daily; then exit 1; fi
done