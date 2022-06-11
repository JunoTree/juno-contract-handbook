---
layout: default
title: インストール
parent: 基本操作
nav_order: 2
---

# インストール

## Rust

### Rustをインストールする

Rustのインストールについては、以下のリンクを参照してください

[https://rustup.rs/](https://rustup.rs/)

### wasm32ターゲットをインストールします

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

goのインストールとセットアップについては、[公式ドキュメント]（https://go.dev/doc/install）を参照してください。
最新バージョンの`wasmd`には、goバージョンv1.17+が必要です。

### wasmd

wasmdは、CosmWasmプラットフォーム用のツールです。

```
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout v0.23.0
make install

# verify the installation
wasmd version
```

問題がある場合は、PATHを確認してください。`makeinstall`はデフォルトで`wasmd`を`$ HOME / go/bin`にコピーします。PATHが設定されていることを確認してください。

