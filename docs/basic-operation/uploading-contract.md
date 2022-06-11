---
layout: default
title: 上傳合約到鏈上
parent: 基礎操作
nav_order: 3
---

# 上傳合約到鏈上

## 1. 上傳合約

```
RES=$(wasmd tx wasm store artifacts/cw_nameservice.wasm --from wallet $TXFLAG -y --output json -b block)
```

## 2. 獲得CODE_ID

在上傳wasm文件後，CODE_ID是這個wasm程序在鏈上的ID。

```
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID
```
