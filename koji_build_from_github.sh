#!/bin/bash

package=$1
release=$2
if [ "$release" = "f39" ]; then
    build_target="f39-build"
    branch="f39-rv64"
elif [ "$release" = "f40" ]; then
    build_target="f40"
    branch="rawhide-rv64"
else
    echo "Invalid release specified."
    exit 1
fi
#success_file="success.txt"
# build_command="koji -p openkoji build --nowait f39-build git+https://src.fedoraproject.org/rpms/{package}.git#{sha}"
build_command="koji -p openkoji call build src=git+https://github.com/fedora-riscv/{package}.git#{sha} target=$build_target channel=physical"

# 逐行读取 success.txt 文件中的包名
#while read package
#do
  echo "Building $package..."

  # 获取 SHA-1 值
  # sha=$(git ls-remote https://src.fedoraproject.org/rpms/$package.git | grep refs/heads/f38 | awk '{print $1}')
  sha=$(git ls-remote https:///github.com/fedora-riscv/$package.git | grep refs/heads/$branch | awk '{print $1}')

  if [ "${sha}" == "" ]; then
      echo $package >> failed.txt
      continue
  fi
  # 替换构建命令中的包名和 SHA-1 值
  command="${build_command/\{package\}/$package}"
  command="${command/\{sha\}/$sha}"

  # 执行构建命令
  echo "$command"
  # eval "$command"

  output=`$command`
  echo "$output"

  regex='Created task: ([0-9]+)'

  if [[ $output =~ $regex ]]; then
    task_id=${BASH_REMATCH[1]}
    echo "Task ID is: $task_id"
  else
    echo "Task ID not found"
  fi

  # nohup sh ./watch_task/watcher.sh $task_id "$package 编译任务完成咯~" > /dev/null 2>&1 &

#done < "$success_file"
