---
layout: default
title: 契約からの転送
parent: 契約開発
nav_order: 5
---

# 契約からの転送

この章では、契約から送金する方法について説明します。

サンプルコード：

https://github.com/JunoTree/cw-handbook/tree/transfer-from-contract

## 1. メッセージを定義する

`msg.rs`ファイルの`ExecuteMsg`構造に`Withdraw`メッセージを追加する必要があります。

```
use cosmwasm_std::Uint128;
...

pub enum ExecuteMsg {
    ...
    Withdraw { amount: Uint128 },
}
```

## 2. メッセージをメソッドにマップします。

`contract.rs`ファイルの`execute`関数にメッセージマップを追加します。

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

## 3. メッセージハンドラーを作成する

`contract.rs`ファイルにメッセージハンドラ関数を追加します。


ハンドラー関数で、戻り値BankMsg::Sendにメッセージを追加します。 契約をユーザーに転送する機能を実装しています。

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

## 4. コントラクトをコンパイルして初期化します

CLIに戻り、次のコマンドを実行します。

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

## 5. 関数を呼び出す

`Withdraw`という名前の`ExecuteMsg`を定義したので、以下の`withdraw`メッセージで呼び出すことができます。

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

