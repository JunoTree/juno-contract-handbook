---
layout: default
title: 初始化合約
parent: 基礎操作
nav_order: 4
---

# 初始化合約

## 初始化合約

因為合約的初始化消息定義如下，它包含了一個count參數。

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct InstantiateMsg {
    pub count: i32,
}
```

我們根據這個結構去調用它。

```
# Get wallet address
ADDR=$(wasmd keys show -a wallet)

# Initialization message
INIT='{"count": 0}'

# Initialize contract by $CODE_ID and $INIT.
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR
```

## 查詢合約地址

```
# check the contract state (and account balance)
wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
echo $CONTRACT
```

## 查詢合約地址的狀態和余額

```
wasmd query wasm contract $CONTRACT $NODE
wasmd query bank balances $CONTRACT $NODE
```
