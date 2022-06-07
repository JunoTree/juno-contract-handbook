---
layout: default
title: Save and query status
parent: Contract development
nav_order: 3
---

# Save and query status

In this chapter, we will look at how to save and query state to the contract.

Sample code

https://github.com/JunoTree/cw-handbook/tree/add-state


## 1. Define state storage variables in the `state.rs` file

```
pub const NAME: Item<String> = Item::new("name");
```

## 2. Define query message

We need to add the `GetName` message to the `QueryMsg` structure in the `msg.rs` file.

```
pub enum QueryMsg {
    ...
    GetName {},
}
```

And add the Response data structure for the query return result

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct NameResponse {
    pub name: String,
}
```

## 3. Map messages to methods

Add a message map in the `query` function of the `contract.rs` file.

```
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> StdResult<Binary> {
    match msg {
        ...
        QueryMsg::GetName {} => to_binary(&query_name(deps)?),
    }
}
```

## 4. Compile a message handler

Add message handler functions in `contract.rs` file.

```
fn query_name(deps: Deps) -> StdResult<NameResponse> {
    let name = NAME.load(deps.storage)?;
    Ok(NameResponse { name })
}
```

## 5. Compile and initialize the contract

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

HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```

## 6. Query status

Since we defined `QueryMsg` named `GetName`, we can invoke it with the `get_name` message below.

```
NAME_QUERY='{"get_name": {}}'
wasmd query wasm contract-state smart $CONTRACT "$NAME_QUERY" $NODE
```
