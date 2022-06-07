---
layout: default
title: Set up the development environment
parent: Basic operation
nav_order: 1
---

# Set up the development environment

## Set chain environment variables

We will configure and use cliffnet-1 as the development and testing environment.

cliffnet-1 is a chain for developing and testing cosmwasm contracts, its token unit is `PEBBLE`, and the unit is `upebble`. 1 `PEBBLE` = 1000000 `upebble`.

Blockchain browser URL： https://block-explorer.cliffnet.cosmwasm.com

We utilize curl to acquire the environment configuration variables of the cliffnet-1 testnet and configure them to the current equipment. The wasmd commands will apply the environment variables.

```
source <(curl -sSL https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env)
```

The content of `https://raw.githubusercontent.com/CosmWasm/testnets/master/cliffnet-1/defaults.env` is as follows
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

As you can see, it includes some environment variables.

## Set up wallet

Create two wallets, called wallet, wallet2 separately.

```
wasmd keys add wallet
wasmd keys add wallet2
```

The output is as follows

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

## Acquire some tokens from the testnet

Next, we use wallet to request some tokens from the testnet.

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

In the above command:
1. Apply `wasmd keys show -a wallet` to get the wallet address.
2. Apply the `jq` command to set the wallet address as the `addr` variable to `{"denom":"upebble","address":$addr}`. The result is as follows: `{"denom":"upebble","address":"wasm1evvnsrte3rdghy506vu4c87x0s5wx0hpppqdd6"}`, assign it to the `JSON` variable.
3. Applying `JSON` as the request parameter, use curl to send a POST request to https://faucet.cliffnet.cosmwasm.com/credit.

Similarly, use the wallet2 to request some tokens from the testnet.

```
JSON=$(jq -n --arg addr $(wasmd keys show -a wallet2) '{"denom":"upebble","address":$addr}') && curl -X POST --header "Content-Type: application/json" --data "$JSON" https://faucet.cliffnet.cosmwasm.com/credit
```

## Check wallet balance

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

You can also query the balance through the blockchain browser.

![explorer](/assets/images/setup-development-environment/explorer.png)


