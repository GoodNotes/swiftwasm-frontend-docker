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
RUN apt-get update && apt-get install -y openjdk-${OPEN_JDK_VERSION}-jre-headless nodejs \
    libcurl4 \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install --global yarn

# Install cypress
RUN npm install --global cypress@${CYPRESS_VERSION}

# Intall swift lint from docker
COPY --from=swiftLint /usr/bin/swiftlint /usr/bin/swiftlint

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version
RUN swiftlint --version