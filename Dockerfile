FROM ubuntu:22.04
LABEL org.opencontainers.image.title="Pizzi Document Builder"
LABEL org.opencontainers.image.source="https://github.com/PizziPayment/DocumentBuilder"
LABEL org.opencontainers.image.url="https://github.com/PizziPayment/DocumentBuilder"
LABEL org.opencontainers.image.description="An image to build PDF document."

VOLUME /source
WORKDIR /source

RUN apt-get update && apt-get install -y \
  pandoc \
  make \
  wget \
  python3 \
  python3-yaml \
  && rm -rf /var/lib/apt/lists/*

# Install tectonic
RUN cd /tmp && \
  TECTONIC_VERSION='0.9.0' \
  TECTONIC_ARCHIVE="tectonic-${TECTONIC_VERSION}-x86_64-unknown-linux-musl.tar.gz"; \
  TECTONIC_URL="https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%40${TECTONIC_VERSION}/${TECTONIC_ARCHIVE}"; \
  wget $TECTONIC_URL \
  && tar -xf $TECTONIC_ARCHIVE \
  && mv tectonic /usr/local/bin \
  && rm $TECTONIC_ARCHIVE

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
