# swiftwasm-frontend-docker
[![CI-Docker](https://github.com/GoodNotes/swiftwasm-frontend-docker/actions/workflows/docker.yml/badge.svg)](https://github.com/GoodNotes/swiftwasm-frontend-docker/actions/workflows/docker.yml)

Repo for generating a docker image with all the needed tools usually for a Frontend Project with Swift WebAssembly.

Creating a frontend application using Swift WASM and React tecnologies requires the use of several tools. 
This is why in order to speed up and simplify logic in the CI we have created this docker image, including all the needed tools using either for compile project, test it and even generate the artifacts.


The collection of tools included are:
- Swift Web Assembly toolchain
- Carton
- NodeJS
- Yarn
- SwiftLint
- Swift Format
- Cypress
- Google Chrome

## Build the image locally

```
$ docker build \
    --build-arg SWIFLINT_DOCKER_IMAGE=ghcr.io/realm/swiftlint:0.46.5 \
    --build-arg CARTON_DOCKER_IMAGE=ghcr.io/swiftwasm/carton:0.16.0 \
    --build-arg SWIFT_DOCKER_IMAGE=swift:5.6 \
    --build-arg SWIFT_TAG=swift-wasm-5.6.0-RELEASE \
    --build-arg SWIFT_FORMAT_TAG=0.50600.0 \
    --build-arg NODE_VERSION=16.x \
    --build-arg OPEN_JDK_VERSION=11 \
    --build-arg CYPRESS_VERSION=8.5.0 \
    --build-arg FIREFOX_VERSION=99.0.1 \
    --build-arg CHROME_VERSION=101.0.4951.54 \
    --build-arg CHROME_DRIVER_VERSION=101.0.4951.41 \
    --build-arg SYMBOLICATOR_VERSION=0.5.0 - < Dockerfile
```

## [TAGGED VERSIONS](https://github.com/GoodNotes/swiftwasm-frontend-docker/pkgs/container/swiftwasm-frontend-docker)
Here you are a list of the tagged dockers with the specific tools version included.

### 0.0.15:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.16.0`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- SwiftFormat => `0.50600.1`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- ChromeDriver => `101.0.4951.41`
- Firefox => `99.0.1`
- Sentry Symbolicator => `0.5.0`

### 0.0.14:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.15.3`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- SwiftFormat => `0.50600.1`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- Firefox => `99.0.1`
- Sentry Symbolicator => `0.5.0`

### 0.0.13:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.15.0`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- SwiftFormat => `0.50600.1`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- Firefox => `99.0.1`
- Sentry Symbolicator => `0.5.0`

### 0.0.12:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.15.0`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- SwiftFormat => `0.50600.1`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- Firefox => `99.0.1`

### 0.0.11:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.14.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- SwiftFormat => `0.50600.1`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- Firefox => `99.0.1`

### 0.0.10:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.14.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- Cypress => `8.5.0`
- Brotli => `1.0.9`
- Chrome => `101.0.4951.54`
- Firefox => `99.0.1`

### 0.0.9:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `0.14.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- Cypress => `9.5.1`
- Brotli => `1.0.9`
- Chrome => `95.0.4638.69`


### 0.0.8:
- Swift Web Assembly toolchain => `swift-wasm-5.6.0-RELEASE`
- Carton => `main`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- Cypress => `9.5.1`
- Brotli => `1.0.9`
- Chrome => `95.0.4638.69`

### 0.0.7:
- Swift Web Assembly toolchain => `swift-wasm-5.5-SNAPSHOT-2022-03-10-a`
- Carton => `main`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- Cypress => `9.5.1`
- Brotli => `1.0.9`
- Chrome => `95.0.4638.69`

### 0.0.6:
- Swift Web Assembly toolchain => `swift-wasm-5.5-SNAPSHOT-2022-03-10-a`
- Carton => `0.12.2`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.46.5`
- Cypress => `9.5.1`
- Brotli => `1.0.9`
- Chrome => `95.0.4638.69`

### 0.0.5:
- Swift Web Assembly toolchain => `5.5.0`
- Carton => `0.12.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.45.1`
- Cypress => `9.5.1`
- Brotli => `1.0.9`
- Chrome => `95.0.4638.69`

### 0.0.4:
- Swift Web Assembly toolchain => `5.5.0`
- Carton => `0.12.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.45.1`
- Cypress => `9.5.1`
- Brotli => `1.0.9`

### 0.0.3:
- Swift Web Assembly toolchain => `5.5.0`
- Carton => `0.12.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.45.1`
- Cypress => `9.2.0`
- Brotli => `1.0.9`

### 0.0.2:
- Swift Web Assembly toolchain => `5.5.0`
- Carton => `0.12.1`
- Binaryen => `105`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.45.1`
- Cypress => `9.2.0`

### 0.0.1:
- Swift Web Assembly toolchain => `5.5.0`
- Carton => `0.12.1`
- Binaryen => `97`
- NodeJS => `v16.13.2`
- Npm => `8.1.2`
- Npx => `8.1.2`
- Yarn => `1.22.17`
- SwiftLint => `0.45.1`
- Cypress => `9.2.0`

## Thanks, the GoodNotes team.
