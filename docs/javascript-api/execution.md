---
layout: default
title: 契約の履行
parent: Javascript API
nav_order: 3
---

# 契約の履行

コントラクトのAPIを呼び出す

```
const executionParams = {resolve_record: {name: 'fred'}};
const gasPrice = GasPrice.fromString(`${GAS_PRICE}${TOKEN_SYMBOL}`);
const fee = calculateFee(GAS_LIMIT, this.getGasPrice());
const result = await client.execute(this.account.address, CONTRACT_ADDRESS, openBoxMessage, fee);
consle.log(result);
```
