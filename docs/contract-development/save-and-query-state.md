---
layout: default
title: 保存和查询状态
parent: 合约开发
nav_order: 3
---

# 保存和查询状态

在这个章节里，我们看看如何向合约中保存状态和查询状态。

示例代码

https://github.com/JunoTree/cw-handbook/tree/add-state


## 1. 在`state.rs`文件中定义状态存储变量

```
pub const NAME: Item<String> = Item::new("name");
```

## 2. 定义查询消息

我们需要在`msg.rs`文件的`QueryMsg`结构中添加`GetName`消息。

```
pub enum QueryMsg {
    ...
    GetName {},
}
```

并为查询返回结果添加Response数据结构

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct NameResponse {
    pub name: String,
}
```

## 3. 映射消息到方法。

在`contract.rs`文件的`query`函数中添加消息映射。

```
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> StdResult<Binary> {
    match msg {
        ...
        QueryMsg::GetName {} => to_binary(&query_name(deps)?),
    }
}
```

## 4. 编写消息处理函数

在`contract.rs`文件中添加消息处理函数。

```
fn query_name(deps: Deps) -> StdResult<NameResponse> {
    let name = NAME.load(deps.storage)?;
    Ok(NameResponse { name })
}
```

## 5. 编译并初始化合约

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

HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```

## 6. 查询状态

因为我们定义了名为`GetName`的`QueryMsg`，我们下面可以用`get_name`消息去调用它。

```
NAME_QUERY='{"get_name": {}}'
wasmd query wasm contract-state smart $CONTRACT "$NAME_QUERY" $NODE
```
