# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM rust:1.71 AS buildbase
WORKDIR /src
RUN <<EOT bash
set -ex
rustup target add wasm32-wasi
EOT

FROM buildbase AS build
COPY Cargo.toml ./
COPY src ./src
# Build the Wasm binary
RUN cargo build --target wasm32-wasi --release
# This line builds the AOT Wasm binary
RUN cp target/wasm32-wasi/release/wasm.wasm wasm.wasm
RUN chmod a+x wasm.wasm

FROM scratch
ENTRYPOINT [ "/wasm.wasm" ]
COPY --link --from=build /src/wasm.wasm /wasm.wasm
LABEL org.opencontainers.image.source=https://github.com/aalonsolopez/terminology-service