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
- Cypress

## Build the image locally

```
$ docker build \
    --build-arg SWIFLINT_DOCKER_IMAGE=ghcr.io/norio-nomura/swiftlint:0.45.1_swift-5.5.0 \
    --build-arg CARTON_DOCKER_IMAGE=ghcr.io/swiftwasm/carton:0.12.1 \
    --build-arg NODE_VERSION=16.x \
    --build-arg OPEN_JDK_VERSION=11 \
    --build-arg CYPRESS_VERSION=9.2.0 - < Dockerfile
```

## [TAGGED VERSIONS](https://github.com/GoodNotes/swiftwasm-frontend-docker/pkgs/container/swiftwasm-frontend-docker)
Here you are a list of the tagged dockers with the specific tools version included.

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

## Thanks, the GoodNotes team.