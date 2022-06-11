---
layout: default
title: 安裝
parent: 基礎操作
nav_order: 2
---

# 安裝

## Rust

### 安裝Rust

請參考下面的鏈接進行Rust的安裝

[https://rustup.rs/](https://rustup.rs/)

### 安裝wasm32 target

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

你可以參考[official documentation](https://go.dev/doc/install)進行go的安裝和設置。 最新版本的`wasmd`需要go的版本是v1.17+。

### wasmd

wasmd是CosmWasm平臺的工具。

```
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout v0.23.0
make install

# verify the installation
wasmd version
```

如果你有任何的問題, 請檢查你的PATH. `make install`默認會復製`wasmd`到`$HOME/go/bin`, 請確實你已經設置好了PATH.

