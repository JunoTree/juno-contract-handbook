---
layout: default
title: 계약의 실행
parent: Javascript API
nav_order: 3
---

# 계약의 실행

계약의 API 호출

```
const executionParams = {resolve_record: {name: 'fred'}};
const gasPrice = GasPrice.fromString(`${GAS_PRICE}${TOKEN_SYMBOL}`);
const fee = calculateFee(GAS_LIMIT, this.getGasPrice());
const result = await client.execute(this.account.address, CONTRACT_ADDRESS, openBoxMessage, fee);
consle.log(result);
```
