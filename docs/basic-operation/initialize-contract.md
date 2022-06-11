---
layout: default
title: 契約を初期化する
parent: 基本操作
nav_order: 4
---

# 契約を初期化する

## 契約を初期化する

コントラクトの初期化メッセージは次のように定義されているため、カウントパラメータが含まれています。

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct InstantiateMsg {
    pub count: i32,
}
```

この構造に従って呼んでいます。

```
# Get wallet address
ADDR=$(wasmd keys show -a wallet)

# Initialization message
INIT='{"count": 0}'

# Initialize contract by $CODE_ID and $INIT.
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR
```

## 契約アドレスを照会する

```
# check the contract state (and account balance)
wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
echo $CONTRACT
```

## 契約アドレスのステータスと残高を照会する

```
wasmd query wasm contract $CONTRACT $NODE
wasmd query bank balances $CONTRACT $NODE
```
