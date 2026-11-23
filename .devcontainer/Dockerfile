# Everything to build the deck: Typst, LibreOffice (PDF to ODP), touying-exporter.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG TYPST_VERSION=0.15.1
RUN apt-get update \
 && apt-get install -y --no-install-recommends libreoffice-impress python3-pip xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && curl -sL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" \
    | tar xJ -C /usr/local/bin --strip-components=1 typst-x86_64-unknown-linux-musl/typst \
 && pip install --no-cache-dir --break-system-packages touying==0.14.4
