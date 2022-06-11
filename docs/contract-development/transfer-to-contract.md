---
layout: default
title: 계약으로 이전
parent: 계약 개발
nav_order: 4
---

# 계약으로 이전

이 장에서는 계약으로 돈을 이체하는 방법을 살펴봅니다.

샘플 코드:

https://github.com/JunoTree/cw-handbook/tree/transfer-to-contract

## 1. 메시지 정의

`msg.rs` 파일의 `ExecuteMsg` 구조에 `Desposit` 메시지를 추가해야 합니다.

```
pub enum ExecuteMsg {
    ...
    Desposit {}
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
        ExecuteMsg::Deposit {} => deposit(deps, info),
    }
}
```

## 3. 메시지 핸들러 작성

`contract.rs` 파일에 메시지 처리기 기능을 추가합니다.

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

`ExecuteMsg`를 `Deposit`으로 정의했기 때문에 아래의 `deposit` 메시지로 호출할 수 있습니다.

**여기서 중요한 것은 `--amount` 매개변수를 사용하여 돈을 계약으로 이체하는 것입니다.**


```
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 100000upebble --from wallet $TXFLAG -y
```

## 6. 계약 잔액 확인

```
wasmd query bank balances $CONTRACT $NODE
```

산출:

```
balances:
- amount: "100000"
  denom: upebble
pagination: {}
```
