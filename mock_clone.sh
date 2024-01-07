#!/bin/bash

# 检查参数是否正确
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PKG_NAME"
  exit 1
fi

PKG_NAME=$1

mkdir -p ${PKG_NAME}_WS
cd ${PKG_NAME}_WS
# 执行git命令
git clone https://src.fedoraproject.org/rpms/${PKG_NAME}.git
cd ${PKG_NAME}
git checkout origin/f39
git checkout -b f39-rv64
fedpkg sources
SRC_FILE=`cat sources | awk '{printf $2}' | sed -e 's/(//g' -e 's/)/ /g'`
git add -f $SRC_FILE && git rm sources
