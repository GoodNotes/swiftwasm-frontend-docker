FROM ghcr.io/swiftwasm/carton:0.12.1 as swiftwasm-builder

# Install curl
RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install strace -y

# Install OpenJDK-11 JRE (needed to run openapi-generator-cli)
RUN apt-get install openjdk-11-jre-headless -y

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN npm install --global yarn

# Print Installed Versions
RUN swift --version
RUN carton --version
RUN node --version
RUN npm --version
RUN npx --version
RUN yarn --version