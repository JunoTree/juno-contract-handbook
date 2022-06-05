---
layout: default
title: 编译合约
parent: 基础操作
nav_order: 2
---

# 编译合约

我们先下载cw-handbook代码作为例子。

```
# get the code
git clone https://github.com/JunoTree/cw-handbook
cd cw-handbook
git checkout create-project
```

编译合约（请确保docker已在你的系统中安装）

```
RUSTFLAGS='-C link-arg=-s' cargo wasm
```
