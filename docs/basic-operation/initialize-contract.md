---
layout: default
title: 初始化合约
parent: 基础操作
nav_order: 5
---

# 初始化合约

## 初始化合约

因为合约的初始化消息定义如下，它包含了一个count参数。

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct InstantiateMsg {
    pub count: i32,
}
```

我们根据这个结构去调用它。

```
# Get wallet address
ADDR=$(wasmd keys show -a wallet)

# Initialization message
INIT='{"count": 0}'

# Initialize contract by $CODE_ID and $INIT.
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR
```

## 查询合约地址

```
# check the contract state (and account balance)
wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
echo $CONTRACT
```

## 查询合约地址的状态和余额

```
wasmd query wasm contract $CONTRACT $NODE
wasmd query bank balances $CONTRACT $NODE
```
