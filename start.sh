#!/bin/bash

# 项目启动脚本 (生产环境)
echo "正在启动 SunStore 前端项目 (生产环境)..."

# 检查是否已有项目在运行
if [ -f ".pid" ]; then
  PID=$(cat .pid)
  if ps -p $PID > /dev/null; then
    echo "项目已经在运行中，进程ID: $PID"
    echo "如需重启，请先执行 ./stop.sh 停止项目"
    exit 1
  else
    echo "发现过期的PID文件，将删除"
    rm -f .pid
  fi
fi

# 安装依赖（如果需要）
if [ "$1" == "--install" ] || [ "$1" == "-i" ]; then
  echo "正在安装依赖..."
  pnpm install
fi

# 构建并启动项目
echo "正在构建项目..."
pnpm run build

echo "正在启动生产服务器..."
nohup pnpm run start > app.log 2>&1 &

# 保存进程ID
echo $! > .pid
echo "项目已启动，进程ID: $!"
echo "日志保存在 app.log 文件中"
echo "可以通过 ./stop.sh 停止项目"
