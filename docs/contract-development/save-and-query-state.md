---
layout: default
title: ステータスの保存とクエリ
parent: 契約開発
nav_order: 3
---

# ステータスの保存とクエリ

この章では、状態をコントラクトに保存して照会する方法について説明します。

サンプルコード

https://github.com/JunoTree/cw-handbook/tree/add-state


## 1. `state.rs`ファイルで状態ストレージ変数を定義します

```
pub const NAME: Item<String> = Item::new("name");
```

## 2. クエリメッセージを定義する

`msg.rs`ファイルの`QueryMsg`構造に`GetName`メッセージを追加する必要があります。

```
pub enum QueryMsg {
    ...
    GetName {},
}
```

そして、クエリの戻り結果の応答データ構造を追加します

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct NameResponse {
    pub name: String,
}
```

## 3. メッセージをメソッドにマップします。

`contract.rs`ファイルの`query`関数にメッセージマップを追加します。

```
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> StdResult<Binary> {
    match msg {
        ...
        QueryMsg::GetName {} => to_binary(&query_name(deps)?),
    }
}
```

## 4. メッセージハンドラーを作成する

`contract.rs`ファイルにメッセージハンドラ関数を追加します。

```
fn query_name(deps: Deps) -> StdResult<NameResponse> {
    let name = NAME.load(deps.storage)?;
    Ok(NameResponse { name })
}
```

## 5. コントラクトをコンパイルして初期化します

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

HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```

## 6. クエリステータス

`GetName`という名前の`QueryMsg`を定義したので、以下の`get_name`メッセージで呼び出すことができます。

```
NAME_QUERY='{"get_name": {}}'
wasmd query wasm contract-state smart $CONTRACT "$NAME_QUERY" $NODE
```
