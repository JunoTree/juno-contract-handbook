---
layout: default
title: 保存和查詢狀態
parent: 合約開發
nav_order: 3
---

# 保存和查詢狀態

在這個章節裏，我們看看如何向合約中保存狀態和查詢狀態。

示例代碼

https://github.com/JunoTree/cw-handbook/tree/add-state


## 1. 在`state.rs`文件中定義狀態存儲變量

```
pub const NAME: Item<String> = Item::new("name");
```

## 2. 定義查詢消息

我們需要在`msg.rs`文件的`QueryMsg`結構中添加`GetName`消息。

```
pub enum QueryMsg {
    ...
    GetName {},
}
```

並為查詢返回結果添加Response數據結構

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct NameResponse {
    pub name: String,
}
```

## 3. 映射消息到方法。

在`contract.rs`文件的`query`函數中添加消息映射。

```
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> StdResult<Binary> {
    match msg {
        ...
        QueryMsg::GetName {} => to_binary(&query_name(deps)?),
    }
}
```

## 4. 編寫消息處理函數

在`contract.rs`文件中添加消息處理函數。

```
fn query_name(deps: Deps) -> StdResult<NameResponse> {
    let name = NAME.load(deps.storage)?;
    Ok(NameResponse { name })
}
```

## 5. 編譯並初始化合約

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

HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```

## 6. 查詢狀態

因為我們定義了名為`GetName`的`QueryMsg`，我們下面可以用`get_name`消息去調用它。

```
NAME_QUERY='{"get_name": {}}'
wasmd query wasm contract-state smart $CONTRACT "$NAME_QUERY" $NODE
```
