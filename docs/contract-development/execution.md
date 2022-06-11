---
layout: default
title: 合約執行
parent: 合約開發
nav_order: 2
---

# 合約執行

在這個章節裏，我們看看如何向合約中添加一個可調用的函數，並執行它。

示例代碼

https://github.com/JunoTree/cw-handbook/tree/add-hello-function

## 1. 定義消息

`msg.rs`是所有消息定義的地方，包括InstantiateMsg，ExecuteMsg，QueryMsg。

我們需要在`msg.rs`文件的`ExecuteMsg`結構中添加`Hello`消息。

```
pub enum ExecuteMsg {
    ...
    Hello {}
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
        ExecuteMsg::Hello {} => hello(deps),
    }
}
```

## 3. 編寫消息處理函數

在`contract.rs`文件中添加消息處理函數。

```
pub fn hello(_deps: DepsMut) -> Result<Response, ContractError> {
    let hello_with_name = format!("hello, {}!", name);
    Ok(Response::new()
        .add_attribute("method", "hello")
        .add_attribute("hello_with_name", hello_with_name))
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

因為我們定義了名為`Hello`的`ExecuteMsg`，我們下面可以用`hello`消息去調用它。

```
HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```


