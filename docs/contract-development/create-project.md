---
layout: default
title: 创建工程
parent: 合约开发
nav_order: 1
---

# 创建工程

## 安装crate

安装用于创建工程的crate

```
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

## 创建工程

下面的命令会基于模板（https://github.com/CosmWasm/cw-template.git）去创建一个工程

```
cargo generate --git https://github.com/CosmWasm/cw-template.git --name cw-handbook

```
