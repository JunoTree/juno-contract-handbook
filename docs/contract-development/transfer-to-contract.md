---
layout: default
title: Transfer to the contract
parent: Contract development
nav_order: 4
---

# Transfer to contract

In this chapter, we will look at how to transfer money to a contract.

Sample code:

https://github.com/JunoTree/cw-handbook/tree/transfer-to-contract

## 1. Define message

We need to add the `Desposit` message in the `ExecuteMsg` structure of the `msg.rs` file.

```
pub enum ExecuteMsg {
    ...
    Desposit {}
}
```

## 2. Map messages to methods

Add a message map in the `execute` function of the `contract.rs` file.

```
pub fn execute(
    deps: DepsMut,
    _env: Env,
    info: MessageInfo,
    msg: ExecuteMsg,
) -> Result<Response, ContractError> {
    match msg {
        ...
        ExecuteMsg::Deposit {} => deposit(deps, info),
    }
}
```

## 3. Compile a message handler

Add message handler functions in `contract.rs` file.

```
use cw_utils::must_pay;

pub fn deposit(_deps: DepsMut, info: MessageInfo) -> Result<Response, ContractError> {
    let payment = must_pay(&info, "upebble")?;
    Ok(Response::new()
        .add_attribute("method", "deposit")
        .add_attribute("payment", payment)
    )
}

```

## 4. Compile and initialize the contract

We go back to the CLI and execute the following command.

```
# Compile
RUSTFLAGS='-C link-arg=-s' cargo wasm

# Upload wasm file
RES=$(wasmd tx wasm store target/wasm32-unknown-unknown/release/cw_handbook.wasm --from wallet4 $TXFLAG -y --output json -b block)

CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')

# Initalize contract
ADDR=$(wasmd keys show -a wallet)
INIT='{"count": 0}'
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR

# Set CONTRACT variable.
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
```

## 5. Invoke function

Since we defined `ExecuteMsg` named `Deposit`, we can invoke it with the `deposit` message below.

**Please note here is to use the `--amount` parameter to transfer money to the contract. **

```
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 100000upebble --from wallet $TXFLAG -y
```

## 6. Query the contract balance

```
wasmd query bank balances $CONTRACT $NODE
```

Output：

```
balances:
- amount: "100000"
  denom: upebble
pagination: {}
```
