FROM debian:stretch-slim

RUN set -ex; \
    addgroup --system mailroom; \
    adduser --system --ingroup mailroom mailroom

# Install ca-certificates so HTTPS works in general
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG MAILROOM_REPO
ENV MAILROOM_REPO ${MAILROOM_REPO:-nyaruka/mailroom}
ARG MAILROOM_VERSION
ENV MAILROOM_VERSION ${MAILROOM_VERSION:-5.3.9}

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends wget; \
    rm -rf /var/lib/apt/lists/*; \
    \
    wget -O mailroom.tar.gz "https://github.com/$MAILROOM_REPO/releases/download/v${MAILROOM_VERSION}/mailroom_${MAILROOM_VERSION}_linux_amd64.tar.gz"; \
    mkdir /usr/local/src/mailroom; \
    tar -xzC /usr/local/src/mailroom -f mailroom.tar.gz; \
    \
    # Just grab the binary and docs files
    ln  -s /usr/local/src/mailroom/mailroom /usr/local/bin/mailroom; \
    apt-get purge -y --auto-remove wget

WORKDIR /usr/local/src/mailroom

EXPOSE 8080

USER mailroom

ENTRYPOINT []
CMD ["mailroom"]
