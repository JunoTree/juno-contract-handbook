---
layout: default
title: 契約への転送
parent: 契約開発
nav_order: 4
---

# 契約への転送

この章では、契約に送金する方法について説明します。

サンプルコード：

https://github.com/JunoTree/cw-handbook/tree/transfer-to-contract

## 1. メッセージを定義する

`msg.rs`ファイルの`ExecuteMsg`構造に`Desposit`メッセージを追加する必要があります。

```
pub enum ExecuteMsg {
    ...
    Desposit {}
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
        ExecuteMsg::Deposit {} => deposit(deps, info),
    }
}
```

## 3. メッセージハンドラーを作成する

`contract.rs`ファイルにメッセージハンドラ関数を追加します。

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

`Deposit`という名前の`ExecuteMsg`を定義したので、以下の`deposit`メッセージで呼び出すことができます。

**ここで重要なのは、`--amount`パラメータを使用してお金を契約に送金することです。**

```
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 100000upebble --from wallet $TXFLAG -y
```

## 6. 契約残高を確認する

```
wasmd query bank balances $CONTRACT $NODE
```

出力：

```
balances:
- amount: "100000"
  denom: upebble
pagination: {}
```
