---
layout: default
title: 合约执行
parent: 合约开发
nav_order: 2
---

# 合约执行

在这个章节里，我们看看如何向合约中添加一个可调用的函数，并执行它。

示例代码

https://github.com/JunoTree/cw-handbook/tree/add-hello-function

## 1. 定义消息

`msg.rs`是所有消息定义的地方，包括InstantiateMsg，ExecuteMsg，QueryMsg。

我们需要在`msg.rs`文件的`ExecuteMsg`结构中添加`Hello`消息。

```
pub enum ExecuteMsg {
    ...
    Hello {}
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
        ExecuteMsg::Hello {} => hello(deps),
    }
}
```

## 3. 编写消息处理函数

在`contract.rs`文件中添加消息处理函数。

```
pub fn hello(_deps: DepsMut) -> Result<Response, ContractError> {
    let hello_with_name = format!("hello, {}!", name);
    Ok(Response::new()
        .add_attribute("method", "hello")
        .add_attribute("hello_with_name", hello_with_name))
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

因为我们定义了名为`Hello`的`ExecuteMsg`，我们下面可以用`hello`消息去调用它。

```
HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```


