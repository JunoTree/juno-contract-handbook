---
layout: default
title: 계약에서 양도
parent: 계약 개발
nav_order: 5
---

# 계약에서 양도

이 장에서는 계약에서 돈을 이체하는 방법을 살펴봅니다.

샘플 코드:

https://github.com/JunoTree/cw-handbook/tree/transfer-from-contract

## 1. 메시지 정의

`msg.rs` 파일의 `ExecuteMsg` 구조에 `Withdraw` 메시지를 추가해야 합니다.

```
use cosmwasm_std::Uint128;
...

pub enum ExecuteMsg {
    ...
    Withdraw { amount: Uint128 },
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
        ExecuteMsg::Withdraw { amount } => withdraw(deps, info, amount),
    }
}
```

## 3. 메시지 핸들러 작성

`contract.rs` 파일에 메시지 처리기 기능을 추가합니다.


핸들러 함수에서 반환에 BankMsg::Send 메시지를 추가합니다. 사용자에게 계약을 이전하는 기능을 구현합니다.

```
use cw_utils::must_pay;

pub fn withdraw(_deps: DepsMut, info: MessageInfo, amount: Uint128) -> Result<Response, ContractError> {
    Ok(Response::new().add_attribute("method", "withdraw")
        .add_message(BankMsg::Send {
            to_address: info.sender.to_string(),
            amount: coins(amount.u128(), "upebble"),
        }))
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

우리는 `Withdraw`라는 이름의 `ExecuteMsg`를 정의했으므로 아래의 `withdraw` 메시지와 함께 호출할 수 있습니다.

```
# Deposit to contract
DEPOSIT='{"deposit": {}}'
wasmd tx wasm execute $CONTRACT "$DEPOSIT" --amount 1000000upebble --from wallet $TXFLAG -y

# Create a new user
wasmd keys add wallet9
ADDR9=$(wasmd keys show -a wallet)

# Get token from faucet
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet9) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit

# Query balance, the balance is 100000000
wasmd query bank balances $ADDR9 $NODE

# Withdraw
wasmd tx wasm execute $CONTRACT "$WITHDRAW" --from wallet9 $TXFLAG -y

# Query balance again, the balance is 100295935.
# The balance is increased, meaning the token is transferred from the contract to the user.
wasmd query bank balances $ADDR9 $NODE

```

