---
layout: default
title: Contract execution
parent: Contract development
nav_order: 2
---

# Contract execution

In this chapter, we can look at how to add a callable function to a contract and execute it.

Sample code

https://github.com/JunoTree/cw-handbook/tree/add-hello-function

## 1. Define the message

`msg.rs` is where all messages are defined, including InstantiateMsg, ExecuteMsg, QueryMsg.

We need to add the `Hello` message to the `ExecuteMsg` structure in the `msg.rs` file.

```
pub enum ExecuteMsg {
    ...
    Hello {}
}
```

## 2. Map messages to methods.

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
        ExecuteMsg::Hello {} => hello(deps),
    }
}
```

## 3. Compile a message handler

Add message handler functions in `contract.rs` file.

```
pub fn hello(_deps: DepsMut) -> Result<Response, ContractError> {
    let hello_with_name = format!("hello, {}!", name);
    Ok(Response::new()
        .add_attribute("method", "hello")
        .add_attribute("hello_with_name", hello_with_name))
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

Since we defined `ExecuteMsg` named `Hello`, we can invoke it with the `hello` message below.

```
HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```


