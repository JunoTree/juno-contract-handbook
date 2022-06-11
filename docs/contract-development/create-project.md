---
layout: default
title: 프로젝트 생성
parent: 계약 개발
nav_order: 1
---

# 프로젝트 생성

## 설치crate

프로젝트 생성을 위해 crate 설치

```
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

## 프로젝트 생성

다음 명령은 템플릿(https://github.com/CosmWasm/cw-template.git)을 기반으로 프로젝트를 생성합니다.

```
cargo generate --git https://github.com/CosmWasm/cw-template.git --name cw-handbook

```
