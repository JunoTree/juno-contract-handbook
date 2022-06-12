---
layout: default
title: Initializing contract
parent: Basic operation
nav_order: 5
---

# Initializing contract

## Initializing contract

Because the contract's initialization message is defined as follows, it includes a count parameter.

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct InstantiateMsg {
    pub count: i32,
}
```

We can invoke it based on the structure.

```
# Get wallet address
ADDR=$(wasmd keys show -a wallet)

# Initialization message
INIT='{"count": 0}'

# Initialize contract by $CODE_ID and $INIT.
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR
```

## Query contract address

```
# check the contract state (and account balance)
wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
echo $CONTRACT
```

## Query the status and balance of the contract address

```
wasmd query wasm contract $CONTRACT $NODE
wasmd query bank balances $CONTRACT $NODE
```
