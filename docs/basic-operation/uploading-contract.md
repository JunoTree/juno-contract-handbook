---
layout: default
title: 契約をチェーンにアップロードする
parent: 基本操作
nav_order: 3
---

# 契約をチェーンにアップロードする

## 1. アップロード契約

```
RES=$(wasmd tx wasm store artifacts/cw_nameservice.wasm --from wallet $TXFLAG -y --output json -b block)
```

## 2. CODE_IDを取得する

wasmファイルをアップロードした後、CODE_IDはチェーン上のwasmプログラムのIDです。

```
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID
```
