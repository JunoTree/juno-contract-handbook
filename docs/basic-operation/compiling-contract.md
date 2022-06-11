---
layout: default
title: 계약 컴파일
parent: 기본 동작
nav_order: 2
---

# 계약 컴파일

먼저 cw-handbook 코드를 예제로 다운로드해 보겠습니다.

```
# get the code
git clone https://github.com/JunoTree/cw-handbook
cd cw-handbook
git checkout create-project
```

계약 컴파일(시스템에 docker이 설치되어 있는지 확인)

```
RUSTFLAGS='-C link-arg=-s' cargo wasm
```
