# Second stage
FROM ghcr.io/norio-nomura/swiftlint:0.45.1_swift-5.5.0 as swiftLint

FROM ghcr.io/swiftwasm/carton:0.12.1 as swiftwasm-builder

# Install node, OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y openjdk-11-jre-headless nodejs \
    libcurl4 \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install --global yarn

# Intall swift lint from docker
COPY --from=swiftLint /usr/bin/* /usr/bin

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version
RUN swiftlint --version