---
layout: default
title: 上传合约到链上
parent: 基础操作
nav_order: 3
---

# 上传合约到链上

## 1. 上传合约

```
RES=$(wasmd tx wasm store artifacts/cw_nameservice.wasm --from wallet $TXFLAG -y --output json -b block)
```

## 2. 获得CODE_ID

在上传wasm文件后，CODE_ID是这个wasm程序在链上的ID。

```
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID
```
