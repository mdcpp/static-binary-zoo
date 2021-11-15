#!/bin/bash

# Lazy way to get a working 'protoc' compiler on at least some Linux architectures.

cd /build || exit 1

case $(uname -m) in
aarch64)
  download https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-linux-aarch_64.zip protoc.zip 086e40c1658d241b2aefae659778637055b7c02e166fe2c835929a3066d41be3
  ;;
x86_64)
  download https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-linux-x86_64.zip protoc.zip 4b18a69b3093432ee0531bc9bf3c4114f81bde1670ade2875f694180ac8bd7f6
  ;;
i?86)
  download https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-linux-x86_32.zip protoc.zip ba9683d85db7d9f44965b38a5c0b05368d0e02ee21f24de3d29627f095d42de3
  ;;
*)
  echo "Currently I don't know how to get protoc for your host architecture. Sorry. This is going to be sorted out at some point."
  exit 1
  ;;
esac

unzip protoc.zip
