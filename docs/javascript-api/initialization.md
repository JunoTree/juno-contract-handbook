---
layout: default
title: 初期化
parent: Javascript API
nav_order: 2
---

# 初期化

## cosmjsをインポートする

```
import { makeCosmoshubPath } from "@cosmjs/amino";
import { coins, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { assertIsDeliverTxSuccess, calculateFee, GasPrice } from "@cosmjs/stargate";
import { SigningCosmWasmClient } from "@cosmjs/cosmwasm-stargate";
```

## 契約とのやり取りに必要な変数を設定します

```
const RPC_ENDPOINT = 'https://rpc.cliffnet.cosmwasm.com:443';
const WALLET_PREFIX = 'wasm';
const TOKEN_SYMBOL = 'upebble';
const GAS_LIMIT = 200_000;
const GAS_PRICE = 0.025;
const CONTRACT_ADDRESS = '<YOUR_CONTRACT_ADDRESS>';
```
