---
layout: default
title: Project creation
parent: Contract development
nav_order: 1
---

# Project creation

## Install crate

Install the crate used to create the project

```
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

## Project creation

The following command will create a project based on the template (https://github.com/CosmWasm/cw-template.git)

```
cargo generate --git https://github.com/CosmWasm/cw-template.git --name cw-handbook

```
