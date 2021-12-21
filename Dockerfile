FROM alpine:latest

# add entrypoint script and set as executeable
ADD entrypoint.sh /
RUN chmod a+x /entrypoint.sh

# install needed tools
RUN apk add curl jq

# install latest cli
RUN curl -L $(curl -s https://api.github.com/repos/contabo/cntb/releases/latest |grep "browser_download_url" |grep "Linux_x86_64.tar.gz" |cut -d : -f 2,3 |tr -d '\"') |tar xz \
    && mv cntb /usr/local/bin/

# entrypoint
CMD /entrypoint.sh