---
layout: default
title: 合约的执行
parent: Javascript API
nav_order: 3
---

# 合约的执行

调用一个合约的API

```
const executionParams = {resolve_record: {name: 'fred'}};
const gasPrice = GasPrice.fromString(`${GAS_PRICE}${TOKEN_SYMBOL}`);
const fee = calculateFee(GAS_LIMIT, this.getGasPrice());
const result = await client.execute(this.account.address, CONTRACT_ADDRESS, openBoxMessage, fee);
consle.log(result);
```
