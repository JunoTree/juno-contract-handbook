---
layout: default
title: 契約執行
parent: 契約開発
nav_order: 2
---

# 契約執行

この章では、呼び出し可能な関数をコントラクトに追加して実行する方法について説明します。

サンプルコード

https://github.com/JunoTree/cw-handbook/tree/add-hello-function

## 1. メッセージを定義する

`msg.rs`は、InstantiateMsg、ExecuteMsg、QueryMsgを含むすべてのメッセージが定義される場所です。

`msg.rs`ファイルの`ExecuteMsg`構造に`Hello`メッセージを追加する必要があります。

```
pub enum ExecuteMsg {
    ...
    Hello {}
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
        ExecuteMsg::Hello {} => hello(deps),
    }
}
```

## 3. メッセージハンドラーを作成する

`contract.rs`ファイルにメッセージハンドラ関数を追加します。

```
pub fn hello(_deps: DepsMut) -> Result<Response, ContractError> {
    let hello_with_name = format!("hello, {}!", name);
    Ok(Response::new()
        .add_attribute("method", "hello")
        .add_attribute("hello_with_name", hello_with_name))
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

`Hello`という名前の`ExecuteMsg`を定義したので、以下の`hello`メッセージで呼び出すことができます。

```
HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```


