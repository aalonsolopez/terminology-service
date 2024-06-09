FROM rust
WORKDIR /src
COPY . .
RUN cargo build --release
ENTRYPOINT [ "./target/release/standard" ]