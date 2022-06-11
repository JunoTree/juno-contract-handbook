---
layout: default
title: 設置開發環境
parent: 基礎操作
nav_order: 1
---

# 設置開發環境

## 設置鏈環境變量

我們將配置和使用cliffnet-1作為開發和測試的環境。

cliffnet-1是一個用來開發和測試cosmwasm合約的鏈，它的token單位是`PEBBLE`, 單位是`upebble`。1 `PEBBLE` = 1000000 `upebble`。

塊鏈瀏覽器URL： https://block-explorer.cliffnet.cosmwasm.com

我們使用curl獲取cliffnet-1測試網的環境配置變量，並將它們設置到本機。wasmd的命令將使用到這些環境變量。

```
source <(curl -sSL https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env)
```

`https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env`的內容如下：
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

可以看出，它包括了一些環境變量。

## 設置錢包

創建兩個錢包，分別稱為wallet, wallet2。

```
wasmd keys add wallet
wasmd keys add wallet2
```

輸出如下：

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

## 獲取一些測試網token

接著，我們用wallet,錢包向測試網請求一些token。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

在上面的命令中：
1. 使用`wasmd keys show -a wallet`獲得wallet錢包地址。
2. 使用`jq`命令，將錢包地址作為`addr`變量設置到`{"denom":"upebble","address":$addr}`中。結果如下：`{"denom":"upebble","address":"wasm1evvnsrte3rdghy506vu4c87x0s5wx0hpppqdd6"}`，將它賦值到`JSON`變量中。
3. 以`JSON`作為請求參數，使用curl向https://faucet.cliffnet.cosmwasm.com/credit發送POST請求。

同理，使用wallet2錢包向測試網請求一些token。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet2) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

## 查詢錢包余額

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

你也可以通過區塊鏈瀏覽器進行查詢。

![explorer](/assets/images/setup-development-environment/explorer.png)


