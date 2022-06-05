---
layout: default
title: 设置开发环境
parent: 基础操作
nav_order: 1
---

# 设置开发环境

## 设置链环境变量

我们将配置和使用cliffnet-1作为开发和测试的环境。

cliffnet-1是一个用来开发和测试cosmwasm合约的链，它的token单位是`PEBBLE`, 单位是`upebble`。1 `PEBBLE` = 1000000 `upebble`。

块链浏览器URL： https://block-explorer.cliffnet.cosmwasm.com

我们使用curl获取cliffnet-1测试网的环境配置变量，并将它们设置到本机。wasmd的命令将使用到这些环境变量。

```
source <(curl -sSL https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env)
```

`https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env`的内容如下：
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

可以看出，它包括了一些环境变量。

## 设置钱包

创建两个钱包，分别称为wallet, wallet2。

```
wasmd keys add wallet
wasmd keys add wallet2
```

输出如下：

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

## 获取一些测试网token

接着，我们用wallet,钱包向测试网请求一些token。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

在上面的命令中：
1. 使用`wasmd keys show -a wallet`获得wallet钱包地址。
2. 使用`jq`命令，将钱包地址作为`addr`变量设置到`{"denom":"upebble","address":$addr}`中。结果如下：`{"denom":"upebble","address":"wasm1evvnsrte3rdghy506vu4c87x0s5wx0hpppqdd6"}`，将它赋值到`JSON`变量中。
3. 以`JSON`作为请求参数，使用curl向https://faucet.cliffnet.cosmwasm.com/credit发送POST请求。

同理，使用wallet2钱包向测试网请求一些token。

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet2) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

## 查询钱包余额

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

你也可以通过区块链浏览器进行查询。

![explorer](/assets/images/setup-development-environment/explorer.png)


