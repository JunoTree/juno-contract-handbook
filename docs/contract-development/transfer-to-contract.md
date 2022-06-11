---
layout: default
title: 轉賬到合約
parent: 合約開發
nav_order: 4
---

# 轉賬到合約

在這個章節裏，我們看看如何向合約轉賬。

示例代碼:

https://github.com/JunoTree/cw-handbook/tree/transfer-to-contract

## 1. 定義消息

我們需要在`msg.rs`文件的`ExecuteMsg`結構中添加`Desposit`消息。

```
pub enum ExecuteMsg {
    ...
    Desposit {}
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
        ExecuteMsg::Deposit {} => deposit(deps, info),
    }
}
```

## 3. 編寫消息處理函數

在`contract.rs`文件中添加消息處理函數。

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

因為我們定義了名為`Deposit`的`ExecuteMsg`，我們下面可以用`deposit`消息去調用它。

**這裏很重要的是使用了`--amount`參數去向合約進行轉賬。**

```
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 100000upebble --from wallet $TXFLAG -y
```

## 6. 查詢合約余額

```
wasmd query bank balances $CONTRACT $NODE
```

輸出：

```
balances:
- amount: "100000"
  denom: upebble
pagination: {}
```
