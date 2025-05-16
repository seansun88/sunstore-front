#!/bin/bash

# 项目停止脚本
echo "正在停止 SunStore 前端项目..."

# 检查PID文件是否存在
if [ ! -f ".pid" ]; then
  echo "未找到PID文件，项目可能未在运行"
  
  # 尝试查找可能的Next.js进程（开发或生产环境）
  NEXT_PID=$(ps aux | grep "next" | grep -v grep | awk '{print $2}')
  
  if [ -n "$NEXT_PID" ]; then
    echo "找到Next.js进程，PID: $NEXT_PID，正在停止..."
    kill -15 $NEXT_PID
    sleep 2
    
    # 检查进程是否已停止
    if ps -p $NEXT_PID > /dev/null; then
      echo "进程未响应，强制终止..."
      kill -9 $NEXT_PID
    fi
    
    echo "项目已停止"
  else
    echo "未找到运行中的项目进程"
    exit 0
  fi
else
  # 从PID文件获取进程ID
  PID=$(cat .pid)
  
  # 检查进程是否在运行
  if ps -p $PID > /dev/null; then
    echo "正在停止进程ID: $PID"
    kill -15 $PID
    sleep 2
    
    # 检查进程是否已停止
    if ps -p $PID > /dev/null; then
      echo "进程未响应，强制终止..."
      kill -9 $PID
    fi
    
    echo "项目已停止"
  else
    echo "PID文件存在，但进程 $PID 未在运行"
  fi
  
  # 删除PID文件
  rm -f .pid
fi

# 清理可能的日志文件
echo "是否清理日志文件? [y/N]"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  rm -f app.log
  echo "日志文件已清理"
fi

echo "停止操作完成"
