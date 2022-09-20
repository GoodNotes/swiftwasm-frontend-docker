ARG SWIFLINT_DOCKER_IMAGE
ARG CARTON_DOCKER_IMAGE
ARG SWIFT_DOCKER_IMAGE

FROM $SWIFLINT_DOCKER_IMAGE as swiftLint

FROM $CARTON_DOCKER_IMAGE as carton-builder

FROM $SWIFT_DOCKER_IMAGE as swift-format-builder

ARG SWIFT_FORMAT_TAG 
RUN git clone https://github.com/apple/swift-format.git && \
    cd swift-format && \
    git checkout "tags/$SWIFT_FORMAT_TAG" && \
    swift build -c release

FROM ubuntu:latest as binaryen

RUN apt-get update && apt-get install -y curl
RUN curl -L -v -o binaryen.tar.gz https://github.com/WebAssembly/binaryen/releases/download/version_105/binaryen-version_105-x86_64-linux.tar.gz
RUN tar xzvf binaryen.tar.gz

FROM ubuntu:20.04 as symbolicator-builder

ARG SYMBOLICATOR_VERSION
RUN apt-get update && apt-get install -y curl
RUN curl -L -v -o wasm-split https://github.com/getsentry/symbolicator/releases/download/$SYMBOLICATOR_VERSION/wasm-split-Linux-x86_64 && chmod +x wasm-split

FROM ubuntu:20.04 as swiftwasm-builder

ARG SWIFT_TAG
ARG NODE_VERSION
ARG SWIFT_PLATFORM_SUFFIX=ubuntu20.04_x86_64.tar.gz
ARG OPEN_JDK_VERSION
ARG CYPRESS_VERSION

ARG SWIFT_BIN_URL="https://github.com/swiftwasm/swift/releases/download/$SWIFT_TAG/$SWIFT_TAG-$SWIFT_PLATFORM_SUFFIX"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install node, OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -

# Download and Install swift toolchain (we need snapshot artifact for getting release Foundation library)
RUN curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && rm -rf swift.tar.gz

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

# Intall swift lint from docker
COPY --from=swiftLint /usr/bin/swiftlint /usr/bin/swiftlint
COPY --from=swiftLint /usr/lib/libsourcekitdInProc.so /usr/lib/
COPY --from=swiftLint /usr/lib/libBlocksRuntime.so /usr/lib/
COPY --from=swiftLint /usr/lib/libdispatch.so /usr/lib/

# Install latest carton tool
COPY --from=carton-builder /usr/bin/carton /usr/bin/carton

ENV CARTON_ROOT=/root/.carton

# Strip swift- prefix from tag name, and create symlink under carton sdk
RUN CARTON_DEFAULT_TOOLCHAIN="${SWIFT_TAG#swift-}" && \
  mkdir -p $CARTON_ROOT/sdk && \
  mkdir -p $CARTON_ROOT/sdk/$CARTON_DEFAULT_TOOLCHAIN && \
  ln -s /usr $CARTON_ROOT/sdk/$CARTON_DEFAULT_TOOLCHAIN/usr

# Install latest binaryen tools (carton still uses some legacy version)
COPY --from=binaryen binaryen-version_105/bin/* /usr/local/bin

# Install swift format 
COPY --from=swift-format-builder /lib/x86_64-linux-gnu/libtinfo.so.* /usr/lib/
COPY --from=swift-format-builder /usr/lib/swift/linux/*.so /usr/lib/
COPY --from=swift-format-builder swift-format/.build/release/swift-format /usr/local/bin/swift-format

COPY --from=symbolicator-builder wasm-split /usr/local/bin

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version
RUN swiftlint --version
RUN swift-format --version
RUN cypress --version
RUN wasm-opt --version
RUN brotli --version
RUN google-chrome --version
RUN wasm-split --version
