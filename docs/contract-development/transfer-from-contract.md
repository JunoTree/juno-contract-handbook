---
layout: default
title: 從合約轉賬
parent: 合約開發
nav_order: 5
---

# 從合約轉賬

在這個章節裏，我們看看如何從合約轉賬。

示例代碼:

https://github.com/JunoTree/cw-handbook/tree/transfer-from-contract

## 1. 定義消息

我們需要在`msg.rs`文件的`ExecuteMsg`結構中添加`Withdraw`消息。

```
use cosmwasm_std::Uint128;
...

pub enum ExecuteMsg {
    ...
    Withdraw { amount: Uint128 },
}
```

## 2. 映射消息到方法。

在`contract.rs`文件的`execute`函數中添加消息映射。

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

## 3. 編寫消息處理函數

在`contract.rs`文件中添加消息處理函數。


在處理函數中，在返回中添加一個消息，BankMsg::Send。它實現了合約轉賬到用戶的功能。

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

## 4. 編譯並初始化合約

我們回到CLI，執行下面的命令。

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

## 5. 調用函數

因為我們定義了名為`Withdraw`的`ExecuteMsg`，我們下面可以用`withdraw`消息去調用它。

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

