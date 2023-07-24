#!/usr/bin/env sh

set -eux

# THANK YOU DUDE. https://www.afox.dev/posts/compiling-go-for-synology-nas
#
#     brew install FiloSottile/musl-cross/musl-cross

command rm ./krantor

CC=x86_64-linux-musl-gcc \
  CXX=x86_64-linux-musl-g++ \
  GOARCH=amd64 \
  GOOS=linux \
  CGO_ENABLED=1 \
  go build -ldflags "-linkmode external -extldflags -static"

echo "done."
file ./krantor