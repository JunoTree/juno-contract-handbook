---
layout: default
title: 編譯合約
parent: 基礎操作
nav_order: 2
---

# 編譯合約

我們先下載cw-handbook代碼作為例子。

```
# get the code
git clone https://github.com/JunoTree/cw-handbook
cd cw-handbook
git checkout create-project
```

編譯合約（請確保docker已在你的系統中安裝）

```
RUSTFLAGS='-C link-arg=-s' cargo wasm
```
