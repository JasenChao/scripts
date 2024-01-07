#!/bin/bash

# 检查参数是否正确
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PKG_NAME"
  exit 1
fi

PKG_NAME=$1

# 执行git命令
cd ${PKG_NAME}
git add .
git commit -am "Rebuild for f39"
git push --set-upstream origin f39-rv64 -f
cd ..
./build_origin.sh ${PKG_NAME}
rm -rf ${PKG_NAME}
