ARG SWIFLINT_DOCKER_IMAGE
ARG CARTON_DOCKER_IMAGE

FROM ubuntu:latest as binaryen

RUN apt-get update && apt-get install -y curl
RUN curl -L -v -o binaryen.tar.gz https://github.com/WebAssembly/binaryen/releases/download/version_105/binaryen-version_105-x86_64-linux.tar.gz
RUN tar xzvf binaryen.tar.gz

ARG SWIFLINT_DOCKER_IMAGE
ARG CARTON_DOCKER_IMAGE

FROM $SWIFLINT_DOCKER_IMAGE as swiftLint


ARG CARTON_DOCKER_IMAGE
FROM $CARTON_DOCKER_IMAGE as swiftwasm-builder

ARG NODE_VERSION
ARG OPEN_JDK_VERSION
ARG CYPRESS_VERSION

# Install node, OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-${OPEN_JDK_VERSION}-jre-headless nodejs \
    libcurl4 \
    libxml2 \
    libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install --global yarn

# Install cypress
RUN npm install --global cypress@${CYPRESS_VERSION}

# Intall swift lint from docker
COPY --from=swiftLint /usr/bin/swiftlint /usr/bin/swiftlint
COPY --from=swiftLint /usr/lib/libsourcekitdInProc.so /usr/lib
COPY --from=swiftLint /usr/lib/swift/linux/libBlocksRuntime.so /usr/lib
COPY --from=swiftLint /usr/lib/swift/linux/libdispatch.so /usr/lib

# Install latest binaryen tools (carton still uses some legacy version)
COPY --from=binaryen binaryen-version_105/bin/* /usr/local/bin

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version
RUN swiftlint --version
RUN cypress --version
RUN wasm-opt --version