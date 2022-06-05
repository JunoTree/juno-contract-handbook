---
layout: default
title: 转账到合约
parent: 合约开发
nav_order: 4
---

# 转账到合约

在这个章节里，我们看看如何向合约转账。

示例代码:

https://github.com/JunoTree/cw-handbook/tree/transfer-to-contract

## 1. 定义消息

我们需要在`msg.rs`文件的`ExecuteMsg`结构中添加`Desposit`消息。

```
pub enum ExecuteMsg {
    ...
    Desposit {}
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
        ExecuteMsg::Deposit {} => deposit(deps, info),
    }
}
```

## 3. 编写消息处理函数

在`contract.rs`文件中添加消息处理函数。

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

因为我们定义了名为`Deposit`的`ExecuteMsg`，我们下面可以用`deposit`消息去调用它。

**这里很重要的是使用了`--amount`参数去向合约进行转账。**

```
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 100000upebble --from wallet $TXFLAG -y
```

## 6. 查询合约余额

```
wasmd query bank balances $CONTRACT $NODE
```

输出：

```
balances:
- amount: "100000"
  denom: upebble
pagination: {}
```
