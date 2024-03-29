ARG SWIFLINT_DOCKER_IMAGE
ARG SWIFT_DOCKER_IMAGE

FROM $SWIFT_DOCKER_IMAGE as carton-builder
ARG SWIFT_TAG
ARG CARTON_TAG
RUN apt-get update && apt-get install -y libsqlite3-dev
RUN git clone https://github.com/swiftwasm/carton.git && \
    cd carton && \
    git checkout "tags/$CARTON_TAG" && \
    export CARTON_DEFAULT_TOOLCHAIN=$SWIFT_TAG && \
    swift build -c release && \
    mv .build/release/carton /usr/bin

FROM ubuntu:22.04 as binaryen

RUN apt-get update && apt-get install -y curl
RUN curl -L -v -o binaryen.tar.gz https://github.com/WebAssembly/binaryen/releases/download/version_105/binaryen-version_105-x86_64-linux.tar.gz
RUN tar xzvf binaryen.tar.gz

FROM ubuntu:22.04 as symbolicator-builder

ARG SYMBOLICATOR_VERSION
RUN apt-get update && apt-get install -y curl
RUN curl -L -v -o wasm-split https://github.com/getsentry/symbolicator/releases/download/$SYMBOLICATOR_VERSION/wasm-split-Linux-x86_64 && chmod +x wasm-split

FROM $SWIFT_DOCKER_IMAGE-slim as swiftwasm-builder

ARG SWIFT_TAG
ARG NODE_VERSION
ARG SWIFT_PLATFORM_SUFFIX=ubuntu22.04_x86_64.tar.gz
ARG OPEN_JDK_VERSION
ARG CYPRESS_VERSION

ARG SWIFT_BIN_URL="https://github.com/swiftwasm/swift/releases/download/swift-$SWIFT_TAG/swift-$SWIFT_TAG-$SWIFT_PLATFORM_SUFFIX"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install node, OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -

ENV CARTON_ROOT=/root/.carton

# Download and Install swift toolchain (we need snapshot artifact for getting release Foundation library)
RUN CARTON_DEFAULT_TOOLCHAIN_PATH="$CARTON_ROOT/sdk/${SWIFT_TAG}" \
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
    && mkdir -p "$CARTON_DEFAULT_TOOLCHAIN_PATH" \
    && tar -xzf swift.tar.gz --directory "$CARTON_DEFAULT_TOOLCHAIN_PATH" --strip-components=1 \
    && ln -s "$CARTON_DEFAULT_TOOLCHAIN_PATH" /opt/swiftwasm

ENV PATH="/opt/swiftwasm/usr/bin:$PATH"

# Install all dependencies also Traditional Chinese, Simplified Chinese, Japanese and Korean fonts (noto-cjk)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-${OPEN_JDK_VERSION}-jre-headless nodejs \
    libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    binutils \
    git \
    gnupg2 \
    libc6-dev \
    libcurl4 \
    libedit2 \
    libgcc-9-dev \
    libpython2.7 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2 \
    libz3-dev \
    brotli \
    pkg-config \
    tzdata \
    zlib1g-dev \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-indic \
    fonts-thai-tlwg-ttf \
    unzip \
    libu2f-udev \
    libvulkan1 \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install --global yarn

# Install cypress
RUN npm install --global cypress@${CYPRESS_VERSION}

ARG CHROME_VERSION
ARG CHROME_DRIVER_VERSION
# Install Chrome
# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

USER root

# Chrome dependencies
RUN apt-get update && apt-get install -y wget fonts-liberation libappindicator3-1 xdg-utils
# Chrome browser
RUN wget -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb"
RUN dpkg -i /usr/src/google-chrome-stable_current_amd64.deb
RUN wget "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/bin/chromedriver \
  && rm chromedriver_linux64.zip
RUN apt-get install -f -y

# Install firefox
ARG FIREFOX_VERSION
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 \
  https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && ln -fs /opt/firefox/firefox /usr/bin/firefox

# Install latest carton tool
COPY --from=carton-builder /usr/bin/carton /usr/bin/carton

# Install latest binaryen tools (carton still uses some legacy version)
COPY --from=binaryen binaryen-version_105/bin/* /usr/local/bin

COPY --from=symbolicator-builder wasm-split /usr/local/bin

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version
RUN cypress --version
RUN wasm-opt --version
RUN brotli --version
RUN google-chrome --version
RUN wasm-split --version
