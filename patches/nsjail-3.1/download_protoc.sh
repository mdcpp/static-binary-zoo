#!/bin/bash

# Lazy way to get a working 'protoc' compiler on at least some Linux architectures.

cd /build || exit 1

case $(uname -m) in
aarch64)
  download https://github.com/protocolbuffers/protobuf/releases/download/v21.1/protoc-21.1-linux-aarch_64.zip protoc.zip b8add83f1908d417c1089167ee0e6d946d84600887ded4240e837b8b0c84202e
  ;;
x86_64)
  download https://github.com/protocolbuffers/protobuf/releases/download/v21.1/protoc-21.1-linux-x86_64.zip protoc.zip c9ac47cddd90d4c79bc55964ca9aec2f7fa06034f9bcc8215dd655b975ffd425
  ;;
i?86)
  download https://github.com/protocolbuffers/protobuf/releases/download/v21.1/protoc-21.1-linux-x86_32.zip protoc.zip 760982dee747cb9bd942ddf3501d81f4494c7581e90e48b79549c062a48c787e
  ;;
*)
  echo "Currently I don't know how to get protoc for your host architecture. Sorry. This is going to be sorted out at some point."
  exit 1
  ;;
esac

unzip protoc.zip
