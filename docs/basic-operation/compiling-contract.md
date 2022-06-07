---
layout: default
title: Compiling contract
parent: Basic operation
nav_order: 2
---

# Compiling contract

First, let's download the cw-handbook code as an instance.

```
# get the code
git clone https://github.com/JunoTree/cw-handbook
cd cw-handbook
git checkout create-project
```

Compiling Contract（Please make sure docker is installed in the system）

```
RUSTFLAGS='-C link-arg=-s' cargo wasm
```
