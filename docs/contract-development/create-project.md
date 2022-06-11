---
layout: default
title: 創建工程
parent: 合約開發
nav_order: 1
---

# 創建工程

## 安裝crate

安裝用於創建工程的crate

```
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

## 創建工程

下面的命令會基於模板（https://github.com/CosmWasm/cw-template.git）去創建一個工程

```
cargo generate --git https://github.com/CosmWasm/cw-template.git --name cw-handbook

```
