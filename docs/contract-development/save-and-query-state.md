---
layout: default
title: 상태 저장 및 쿼리
parent: 계약 개발
nav_order: 3
---

# 상태 저장 및 쿼리

이 장에서는 계약에 상태를 저장하고 쿼리하는 방법을 살펴봅니다.

샘플 코드

https://github.com/JunoTree/cw-handbook/tree/add-state


## 1. `state.rs` 파일에 상태 저장 변수 정의

```
pub const NAME: Item<String> = Item::new("name");
```

## 2. 쿼리 메시지 정의

`msg.rs` 파일의 `QueryMsg` 구조에 `GetName` 메시지를 추가해야 합니다.

```
pub enum QueryMsg {
    ...
    GetName {},
}
```

그리고 쿼리 반환 결과에 대해 Response 데이터 구조를 추가합니다.

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct NameResponse {
    pub name: String,
}
```

## 3. 메시지를 메서드에 매핑합니다.

`contract.rs` 파일의 `query` 함수에 메시지 맵을 추가합니다.

```
pub fn query(deps: Deps, _env: Env, msg: QueryMsg) -> StdResult<Binary> {
    match msg {
        ...
        QueryMsg::GetName {} => to_binary(&query_name(deps)?),
    }
}
```

## 4. 메시지 핸들러 작성

`contract.rs` 파일에 메시지 처리기 기능을 추가합니다.

```
fn query_name(deps: Deps) -> StdResult<NameResponse> {
    let name = NAME.load(deps.storage)?;
    Ok(NameResponse { name })
}
```

## 5. 계약 컴파일 및 초기화

CLI로 돌아가서 다음 명령을 실행합니다.

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

## 6. 쿼리 상태

`GetName`이라는 `QueryMsg`를 정의했으므로 아래의 `get_name` 메시지로 호출할 수 있습니다.

```
NAME_QUERY='{"get_name": {}}'
wasmd query wasm contract-state smart $CONTRACT "$NAME_QUERY" $NODE
```
