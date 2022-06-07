---
layout: default
title: initialization
parent: Javascript API
nav_order: 2
---

# Initialization

## Import cosmjs library

```
import { makeCosmoshubPath } from "@cosmjs/amino";
import { coins, DirectSecp256k1HdWallet } from "@cosmjs/proto-signing";
import { assertIsDeliverTxSuccess, calculateFee, GasPrice } from "@cosmjs/stargate";
import { SigningCosmWasmClient } from "@cosmjs/cosmwasm-stargate";
```

## Set the variables needed to interact with the contract

```
const RPC_ENDPOINT = 'https://rpc.cliffnet.cosmwasm.com:443';
const WALLET_PREFIX = 'wasm';
const TOKEN_SYMBOL = 'upebble';
const GAS_LIMIT = 200_000;
const GAS_PRICE = 0.025;
const CONTRACT_ADDRESS = '<YOUR_CONTRACT_ADDRESS>';
```
