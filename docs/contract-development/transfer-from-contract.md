---
layout: default
title: Transfer from contract
parent: Contract development
nav_order: 5
---

# Transfer from contract

In this chapter, we will look at how to transfer money from a contract.

Sample code:

https://github.com/JunoTree/cw-handbook/tree/transfer-from-contract

## 1. Define message

We need to add the `Withdraw` message to the `ExecuteMsg` structure in the `msg.rs` file.

```
use cosmwasm_std::Uint128;
...

pub enum ExecuteMsg {
    ...
    Withdraw { amount: Uint128 },
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
        ExecuteMsg::Withdraw { amount } => withdraw(deps, info, amount),
    }
}
```

## 3. Compile message handler

Add message handler functions in `contract.rs` file.


In the handler function, add a message to the return: BankMsg::Send. It implements the function of transferring contracts to users.

```
use cw_utils::must_pay;

pub fn withdraw(_deps: DepsMut, info: MessageInfo, amount: Uint128) -> Result<Response, ContractError> {
    Ok(Response::new().add_attribute("method", "withdraw")
        .add_message(BankMsg::Send {
            to_address: info.sender.to_string(),
            amount: coins(amount.u128(), "upebble"),
        }))
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

Since we defined `ExecuteMsg` named `Withdraw`, we can invoke it with the `withdraw` message below.

```
# Deposit to contract
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 1000000upebble --from wallet $TXFLAG -y

# Create a new user
wasmd keys add wallet9
ADDR9=$(wasmd keys show -a wallet)

# Get token from faucet
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet9) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit

# Query balance, the balance is 100000000
wasmd query bank balances $ADDR9 $NODE

# Withdraw
wasmd tx wasm execute $CONTRACT "$WITHDRAW" --from wallet9 $TXFLAG -y

# Query balance again, the balance is 100295935.
# The balance is increased, meaning the token is transferred from the contract to the user.
wasmd query bank balances $ADDR9 $NODE

```

