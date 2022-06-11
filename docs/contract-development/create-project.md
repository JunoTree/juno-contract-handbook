---
layout: default
title: プロジェクトを作成する
parent: 契約開発
nav_order: 1
---

# プロジェクトを作成する

## crateをインストール

プロジェクトを作成するためにcrateをインストールします

```
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

## プロジェクトを作成する

次のコマンドは、テンプレート（https://github.com/CosmWasm/cw-template.git）に基づいてプロジェクトを作成します

```
cargo generate --git https://github.com/CosmWasm/cw-template.git --name cw-handbook

```
