---
layout: default
title: 安装
parent: 基础操作
nav_order: 1
---

# 安装

## Rust

### 安装Rust

请参考下面的链接进行Rust的安装

[https://rustup.rs/](https://rustup.rs/)

### 安装wasm32 target

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

你可以参考[official documentation](https://go.dev/doc/install)进行go的安装和设置。 最新版本的`wasmd`需要go的版本是v1.17+。

### wasmd

wasmd是CosmWasm平台的工具。

```
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout v0.23.0
make install

# verify the installation
wasmd version
```

如果你有任何的问题, 请检查你的PATH. `make install`默认会复制`wasmd`到`$HOME/go/bin`, 请确实你已经设置好了PATH.

