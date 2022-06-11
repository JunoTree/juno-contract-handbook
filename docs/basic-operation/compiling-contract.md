---
layout: default
title: 契約をコンパイルする
parent: 基本操作
nav_order: 2
---

# 契約をコンパイルする

まず、例としてcw-handbookコードをダウンロードしましょう。

```
# get the code
git clone https://github.com/JunoTree/cw-handbook
cd cw-handbook
git checkout create-project
```

コントラクトをコンパイルします（dockerがシステムにインストールされていることを確認してください）

```
RUSTFLAGS='-C link-arg=-s' cargo wasm
```
