FROM rustlang/rust:nightly-slim

# Basic tooling = make, curl
# External dependancies = libssl-dev, pkg-config
# Web tooling = npm
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    curl \
    pkg-config \
    libssl-dev \
    npm

COPY rust_env_setup.sh .
RUN sh rust_env_setup.sh

ENV PROJECT_ROOT=/app_src_volume

VOLUME $PROJECT_ROOT
WORKDIR $PROJECT_ROOT

EXPOSE 8080

CMD tail -f /dev/null
