FROM rust:alpine3.15 AS builder
RUN apk add musl-dev --no-cache
WORKDIR /src
COPY . .
RUN cargo build --release

FROM alpine:3.15
WORKDIR /app
COPY --from=builder /src/target/release/standard .
ENTRYPOINT [ "./standard" ]