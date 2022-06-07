---
layout: default
title: Uploading the contract to the chain
parent: Basic operation
nav_order: 3
---

# Uploading the contract to the chain

## 1. Upload the contract

```
RES=$(wasmd tx wasm store artifacts/cw_nameservice.wasm --from wallet $TXFLAG -y --output json -b block)
```

## 2. Get CODE_ID

After uploading the wasm file, CODE_ID is the ID of the wasm program on the chain.

```
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID
```
