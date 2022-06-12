---
layout: default
title: 설치
parent: 기본 동작
nav_order: 1
---

# 설치

## Rust

### 설치Rust

Rust 설치는 아래 링크를 참고해주세요.

[https://rustup.rs/](https://rustup.rs/)

### 설치wasm32 target

```
rustup default stable
cargo version
# If this is lower than 1.55.0+, update
rustup update stable

rustup target list --installed
rustup target add wasm32-unknown-unknown
```

## wasmd

### Go

go 설치 및 설정은 [공식 문서](https://go.dev/doc/install)를 참조하세요. 최신 버전의 `wasmd`를 사용하려면 go 버전 v1.17 이상이 필요합니다.

### wasmd

wasmd는 CosmWasm 플랫폼용 도구입니다.

```
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout v0.23.0
make install

# verify the installation
wasmd version
```

문제가 있으면 경로를 확인하세요. `make install`은 기본적으로 `wasmd`를 `$HOME/go/bin`에 복사하므로 경로를 설정했는지 확인하세요.

