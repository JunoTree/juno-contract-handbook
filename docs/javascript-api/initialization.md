---
layout: default
title: 初始化
parent: Javascript API
nav_order: 2
---

# 初始化

## 导入cosmjs库

```
import { makeCosmoshubPath } from "@cosmjs/amino";
import { coins, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { assertIsDeliverTxSuccess, calculateFee, GasPrice } from "@cosmjs/stargate";
import { SigningCosmWasmClient } from "@cosmjs/cosmwasm-stargate";
```

## 设置与合约交互所需的变量

```
const RPC_ENDPOINT = 'https://rpc.cliffnet.cosmwasm.com:443';
const WALLET_PREFIX = 'wasm';
const TOKEN_SYMBOL = 'upebble';
const GAS_LIMIT = 200_000;
const GAS_PRICE = 0.025;
const CONTRACT_ADDRESS = '<YOUR_CONTRACT_ADDRESS>';
```
