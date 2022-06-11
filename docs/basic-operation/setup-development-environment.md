---
layout: default
title: 開発環境をセットアップする
parent: 基本操作
nav_order: 1
---

# 開発環境をセットアップする

## チェーン環境変数を設定する

Cliffnet-1を開発およびテスト用の環境として構成し、使用します。

cliffnet-1は、cosmwasmコントラクトを開発およびテストするためのチェーンであり、そのトークンユニットは`PEBBLE`であり、ユニットは`upebble`です。 1 `PEBBLE` =1000000`upebble`。

ブラウザのURL： https://block-explorer.cliffnet.cosmwasm.com

curlを使用して、Cliffnet-1テストネットの環境構成変数を取得し、それらをこのマシンに設定します。 これらの環境変数は、wasmdコマンドによって使用されます。

```
source <(curl -sSL https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env)
```

`https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env`内容は以下の通りです。
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

ご覧のとおり、いくつかの環境変数が含まれています。

## ウォレットを設定する

wallet、wallet2と呼ばれる2つのウォレットを作成します。

```
wasmd keys add wallet
wasmd keys add wallet2
```

出力は次のとおりです。

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

## テストネットトークンを取得する

次に、wallet、walletを使用して、テストネットからいくつかのトークンを要求します。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

上記のコマンドでは：
1. `wasmd keys show -a wallet`を使用して、ウォレットアドレスを取得します。
2. `jq`コマンドを使用して、ウォレットアドレスを`addr`変数として`{"denom "：" upebble "、" address "：$addr}`に設定します。 結果は次のようになります。`{"denom"：" upebble "、" address "：" wasm1evvnsrte3rdghy506vu4c87x0s5wx0hpppqdd6 "}`、それを`JSON`変数に割り当てます。
3. リクエストパラメータとして`JSON`を使用し、curlを使用してPOSTリクエストをhttps://faucet.cliffnet.cosmwasm.com/creditに送信します。

同様に、wallet2ウォレットを使用して、テストネットからいくつかのトークンを要求します。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet2) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

## ウォレットのバランスを確認する

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

ブロックチェーンブラウザからクエリを実行することもできます。

![explorer](/assets/images/setup-development-environment/explorer.png)


