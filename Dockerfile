FROM ghcr.io/swiftwasm/carton:0.12.1 as swiftwasm-builder

# Install node, OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y openjdk-11-jre-headless nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN npm install --global yarn

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version