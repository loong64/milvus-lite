#!/bin/bash

set -ex

VERSION=1.50.1

command -v yum >/dev/null && {
    yum install -y zlib-devel c-ares-devel re2-devel openssl-devel
    yum clean all
}

cd /tmp

wget -qO grpc-${VERSION}.tar.gz https://github.com/grpc/grpc/archive/refs/tags/v${VERSION}.tar.gz
tar -xf grpc-${VERSION}.tar.gz

pushd grpc-${VERSION}/cmake

mkdir build && cd build

# https://github.com/conan-io/conan-center-index/blob/master/recipes/grpc/all/conanfile.py
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DgRPC_BUILD_CODEGEN=True -DgRPC_BUILD_CSHARP_EXT=False -DgRPC_BUILD_TESTS=OFF -DgRPC_INSTALL=True -DgRPC_INSTALL_SHAREDIR="res/grpc" -DgRPC_ZLIB_PROVIDER="package" -DgRPC_CARES_PROVIDER="package" -DgRPC_RE2_PROVIDER="package" -DgRPC_SSL_PROVIDER="package" -DgRPC_PROTOBUF_PROVIDER="module" -DgRPC_ABSL_PROVIDER="module" -DgRPC_OPENTELEMETRY_PROVIDER="package" -DgRPC_BUILD_GRPC_CPP_PLUGIN=True -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=True -DgRPC_BUILD_GRPC_NODE_PLUGIN=True -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=True -DgRPC_BUILD_GRPC_PHP_PLUGIN=True -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=True -DgRPC_BUILD_GRPC_RUBY_PLUGIN=True -DgRPC_BUILD_GRPCPP_OTEL_PLUGIN=False
make -j$(nproc)
make install

popd

rm -rf grpc-${VERSION} grpc-${VERSION}.tar.gz

which ldconfig && ldconfig || true
