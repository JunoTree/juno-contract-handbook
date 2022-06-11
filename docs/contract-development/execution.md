---
layout: default
title: 계약 실행
parent: 계약 개발
nav_order: 2
---

# 계약 실행

이 장에서는 호출 가능한 함수를 계약에 추가하고 실행하는 방법을 살펴봅니다.

샘플 코드

https://github.com/JunoTree/cw-handbook/tree/add-hello-function

## 1. 메시지 정의

`msg.rs`는 InstantiateMsg, ExecuteMsg, QueryMsg를 포함한 모든 메시지가 정의되는 곳입니다.

`msg.rs` 파일의 `ExecuteMsg` 구조에 `Hello` 메시지를 추가해야 합니다.

```
pub enum ExecuteMsg {
    ...
    Hello {}
}
```

## 2. 메시지를 메서드에 매핑합니다.

`contract.rs` 파일의 `execute` 기능에 메시지 맵을 추가합니다.

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

## 3. 메시지 핸들러 작성

`contract.rs` 파일에 메시지 처리기 기능을 추가합니다.

```
pub fn hello(_deps: DepsMut) -> Result<Response, ContractError> {
    let hello_with_name = format!("hello, {}!", name);
    Ok(Response::new()
        .add_attribute("method", "hello")
        .add_attribute("hello_with_name", hello_with_name))
}
```

## 4. 계약 컴파일 및 초기화

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
```

## 5. 함수 호출

`ExecuteMsg`를 `Hello`라는 이름으로 정의했으므로 아래의 `hello` 메시지와 함께 호출할 수 있습니다.

```
HELLO='{"hello": {"name": "Jack"}}'
wasmd tx wasm execute $CONTRACT "$HELLO" --from wallet $TXFLAG -y
```


