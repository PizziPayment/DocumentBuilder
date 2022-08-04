FROM node:16-bullseye
LABEL org.opencontainers.image.title="Pizzi Document Builder"
LABEL org.opencontainers.image.source="https://github.com/PizziPayment/DocumentBuilder"
LABEL org.opencontainers.image.url="https://github.com/PizziPayment/DocumentBuilder"
LABEL org.opencontainers.image.description="An image to build PDF document."

ADD puppeteer-config.json  /puppeteer-config.json
ENV PUPPETEER_CFG_PATH="/puppeteer-config.json"

VOLUME /source
WORKDIR /source

RUN apt-get update \
  && apt-get install -y wget gnupg pandoc make python3 python3-yaml \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @mermaid-js/mermaid-cli@9.1.4

# Install tectonic
RUN cd /tmp && \
  TECTONIC_VERSION='0.9.0' \
  TECTONIC_ARCHIVE="tectonic-${TECTONIC_VERSION}-x86_64-unknown-linux-musl.tar.gz"; \
  TECTONIC_URL="https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%40${TECTONIC_VERSION}/${TECTONIC_ARCHIVE}"; \
  wget $TECTONIC_URL \
  && tar -xf $TECTONIC_ARCHIVE \
  && mv tectonic /usr/local/bin \
  && rm $TECTONIC_ARCHIVE \
  && apt-get clean -y wget

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
