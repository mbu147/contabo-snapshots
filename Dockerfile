FROM alpine:3.21

# install needed tools
RUN apk add --no-cache curl jq

# install latest cntb cli
RUN curl -fsSL "$(curl -fsSL https://api.github.com/repos/contabo/cntb/releases/latest \
      | jq -r '.assets[] | select(.name | test("linux_amd64\\.tar\\.gz")) | .browser_download_url')" \
    | tar xz && mv cntb /usr/local/bin/

# add scripts
COPY entrypoint.sh snapshot.sh /
RUN chmod +x /entrypoint.sh /snapshot.sh

# Required
ENV CLIENTID=""
ENV CLIENTSECRET=""
ENV USER=""
ENV PASSWORD=""

# Optional: set a cron expression to run on a schedule (e.g. "0 3 * * *")
# If unset, the snapshot runs once and the container exits.
ENV CRON_SCHEDULE=""

# Optional: snapshot name (default: daily)
ENV SNAPSHOT_NAME="daily"

ENTRYPOINT ["/entrypoint.sh"]
