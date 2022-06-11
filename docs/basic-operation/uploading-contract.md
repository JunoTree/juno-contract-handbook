---
layout: default
title: 체인에 계약 업로드
parent: 기본 동작
nav_order: 3
---

# 체인에 계약 업로드

## 1. 업로드 계약

```
RES=$(wasmd tx wasm store artifacts/cw_nameservice.wasm --from wallet $TXFLAG -y --output json -b block)
```

## 2. CODE_ID 받기

wasm 파일을 업로드한 후 CODE_ID는 체인에 있는 wasm 프로그램의 ID입니다.

```
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID
```
