---
layout: default
title: 계약 초기화
parent: 기본 동작
nav_order: 5
---

# 계약 초기화

## 계약 초기화

계약의 초기화 메시지는 다음과 같이 정의되어 있으므로 count 매개변수를 포함합니다.

```
#[derive(Serialize, Deserialize, Clone, Debug, PartialEq, JsonSchema)]
pub struct InstantiateMsg {
    pub count: i32,
}
```

이 구조에 따라 호출합니다.

```
# Get wallet address
ADDR=$(wasmd keys show -a wallet)

# Initialization message
INIT='{"count": 0}'

# Initialize contract by $CODE_ID and $INIT.
wasmd tx wasm instantiate $CODE_ID "$INIT" --from wallet --label "cw-handbook" $TXFLAG -y --admin $ADDR
```

## 쿼리 계약 주소

```
# check the contract state (and account balance)
wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json
CONTRACT=$(wasmd query wasm list-contract-by-code $CODE_ID $NODE --output json | jq -r '.contracts[-1]')
echo $CONTRACT
```

## 계약 주소의 상태 및 잔액 조회

```
wasmd query wasm contract $CONTRACT $NODE
wasmd query bank balances $CONTRACT $NODE
```
