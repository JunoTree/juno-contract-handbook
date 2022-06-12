---
layout: default
title: 개발 환경 설정
parent: 기본 동작
nav_order: 3
---

# 개발 환경 설정

## 체인 환경 변수 설정

Cliffnet-1을 개발 및 테스트를 위한 환경으로 구성하고 사용할 것입니다.

Cliffnet-1은 cosmwasm 계약을 개발 및 테스트하기 위한 체인으로, 토큰 단위는 `PEBBLE`, 단위는 `upebble`입니다. 1 `PEBBLE` = 1000000 `upebble`.

블록체인 익스플로러 URL: https://block-explorer.cliffnet.cosmwasm.com

curl을 사용하여 Cliffnet-1 테스트넷에 대한 환경 구성 변수를 가져와 이 시스템에 설정합니다. 이러한 환경 변수는 wasmd 명령에서 사용됩니다.

```
source <(curl -sSL https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env)
```

`https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env`의 내용은 다음과 같습니다.
```
export CHAIN_ID="cliffnet-1"
...
export FEE_DENOM="upebble"\
...
export RPC="https://rpc.cliffnet.cosmwasm.com:443"
export FAUCET="https://faucet.cliffnet.cosmwasm.com"
...
export NODE=(--node $RPC)
export TXFLAG=($NODE --chain-id $CHAIN_ID --gas-prices 0.025upebble --gas auto --gas-adjustment 1.3)
```

보시다시피 일부 환경 변수가 포함되어 있습니다.

## 지갑 설정

wallet, wallet2이라는 두 개의 지갑을 만듭니다.

```
wasmd keys add wallet
wasmd keys add wallet2
```

출력은 다음과 같습니다.

```
- name: wallet
  type: local
  address: wasm1lkmecvu06lr8hpak7j4uh2jllvdt78ee4d3sh6
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"A0bry1pEw2qsQWwhN08LZFUFebyzDLYEFTv0EWNvm8QR"}'
  mnemonic: ""


**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

midnight traffic ginger silent once vocal frost silent match cart mistake cancel country foster lunch swamp setup actual dilemma suffer print beef enjoy nest
```

## 테스트넷 token 가져오기

다음으로, 지갑인 wallet을 사용하여 테스트넷에서 일부 token을 요청합니다.

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

위의 명령에서:
1. 지갑 지갑 주소를 얻으려면 `wasmd keys show -wallet`을 사용하세요.
2. `jq` 명령을 사용하여 지갑 주소를 `addr` 변수로 `{"denom":"upebble","address":$addr}`에 설정합니다. 결과는 다음과 같습니다. `{"denom":"upebble","address":"wasm1evvnsrte3rdghy506vu4c87x0s5wx0hpppqdd6"}`, `JSON` 변수에 할당합니다.
3.  curl을 사용하여 `JSON`을 요청 매개변수로 사용하여 https://faucet.cliffnet.cosmwasm.com/credit에 POST 요청을 보냅니다.

마찬가지로 wallet2 지갑을 사용하여 테스트넷에서 일부 토큰을 요청합니다.

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet2) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

## 지갑 잔액 확인

```
ADDR=$(wasmd keys show -a wallet) && wasmd query bank balances $ADDR $NODE
```

Output:

```
balances:
- amount: "100000000"
  denom: upebble
pagination: {}
```

블록체인 브라우저를 통해 쿼리할 수도 있습니다.

![explorer](/assets/images/setup-development-environment/explorer.png)


