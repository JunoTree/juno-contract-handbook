---
layout: default
title: installation
parent: Basic operation
nav_order: 1
---

# Installation

## Rust

### Install Rust

Please refer to the link below for Rust installation

[https://rustup.rs/](https://rustup.rs/)

### Install wasm32 target

```
rustup default stable
cargo version
# If this is lower than 1.55.0+, update
rustup update stable

rustup target list --installed
rustup target add wasm32-unknown-unknown
```

## wasmd

### Go

You can refer to the [official documentation](https://go.dev/doc/install) for go installation and setup. The latest version of `wasmd` requires go version v1.17+.

### wasmd

wasmd is a tool for the CosmWasm platform.

```
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout v0.23.0
make install

# verify the installation
wasmd version
```

If you have any questions, please check your PATH. `make install` will copy `wasmd` to `$HOME/go/bin` by default, make sure you have set your PATH.

