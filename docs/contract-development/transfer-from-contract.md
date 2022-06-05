---
layout: default
title: 从合约转账
parent: 合约开发
nav_order: 5
---

# 从合约转账

在这个章节里，我们看看如何从合约转账。

示例代码:

https://github.com/JunoTree/cw-handbook/tree/transfer-from-contract

## 1. 定义消息

我们需要在`msg.rs`文件的`ExecuteMsg`结构中添加`Withdraw`消息。

```
use cosmwasm_std::Uint128;
...

pub enum ExecuteMsg {
    ...
    Withdraw { amount: Uint128 },
}
```

## 2. 映射消息到方法。

在`contract.rs`文件的`execute`函数中添加消息映射。

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

## 3. 编写消息处理函数

在`contract.rs`文件中添加消息处理函数。


在处理函数中，在返回中添加一个消息，BankMsg::Send。它实现了合约转账到用户的功能。

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

## 4. 编译并初始化合约

我们回到CLI，执行下面的命令。

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

## 5. 调用函数

因为我们定义了名为`Withdraw`的`ExecuteMsg`，我们下面可以用`withdraw`消息去调用它。

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

