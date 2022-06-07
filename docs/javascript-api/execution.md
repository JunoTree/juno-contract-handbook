---
layout: default
title: Contract execution
parent: Javascript API
nav_order: 3
---

# Contract execution

Invoke an API of contract

```
const executionParams = {resolve_record: {name: 'fred'}};
const gasPrice = GasPrice.fromString(`${GAS_PRICE}${TOKEN_SYMBOL}`);
const fee = calculateFee(GAS_LIMIT, this.getGasPrice());
const result = await client.execute(this.account.address, CONTRACT_ADDRESS, openBoxMessage, fee);
consle.log(result);
```