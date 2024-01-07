#!/bin/bash

# 检查参数是否正确
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PKG_NAME"
  exit 1
fi

PKG_NAME=$1

# 执行git命令
git clone git@github.com:fedora-riscv/${PKG_NAME}.git
cd ${PKG_NAME}
git remote add upstream https://src.fedoraproject.org/rpms/${PKG_NAME}.git
git fetch upstream
git checkout upstream/f39
git checkout -b f39-rv64
git merge origin/f38-rv64

