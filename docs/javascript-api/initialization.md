---
layout: default
title: 초기화
parent: Javascript API
nav_order: 2
---

# 초기화

## cosmjs 라이브러리 가져오기

```
import { makeCosmoshubPath } from "@cosmjs/amino";
import { coins, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { assertIsDeliverTxSuccess, calculateFee, GasPrice } from "@cosmjs/stargate";
import { SigningCosmWasmClient } from "@cosmjs/cosmwasm-stargate";
```

## 계약과 상호 작용하는 데 필요한 변수 설정

```
const RPC_ENDPOINT = 'https://rpc.cliffnet.cosmwasm.com:443';
const WALLET_PREFIX = 'wasm';
const TOKEN_SYMBOL = 'upebble';
const GAS_LIMIT = 200_000;
const GAS_PRICE = 0.025;
const CONTRACT_ADDRESS = '<YOUR_CONTRACT_ADDRESS>';
```
