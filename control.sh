#!/bin/bash

# 项目控制脚本
# 用法: ./control.sh [start|stop|restart|status] [options]

# 显示帮助信息
show_help() {
  echo "SunStore前端项目控制脚本"
  echo "用法: ./control.sh [命令] [选项]"
  echo ""
  echo "命令:"
  echo "  start    启动项目"
  echo "  stop     停止项目"
  echo "  restart  重启项目"
  echo "  status   查看项目状态"
  echo ""
  echo "选项:"
  echo "  -i, --install  启动前安装依赖 (仅适用于start和restart命令)"
  echo "  -h, --help     显示帮助信息"
  echo ""
  echo "示例:"
  echo "  ./control.sh start        # 启动项目"
  echo "  ./control.sh start -i     # 安装依赖并启动项目"
  echo "  ./control.sh stop         # 停止项目"
  echo "  ./control.sh restart      # 重启项目"
  echo "  ./control.sh status       # 查看项目状态"
}

# 检查脚本是否存在
check_scripts() {
  if [ ! -f "./start.sh" ] || [ ! -f "./stop.sh" ]; then
    echo "错误: 未找到必要的脚本文件 (start.sh 或 stop.sh)"
    echo "请确保这些文件存在于当前目录"
    exit 1
  fi
  
  # 确保脚本有执行权限
  if [ ! -x "./start.sh" ] || [ ! -x "./stop.sh" ]; then
    echo "正在添加执行权限..."
    chmod +x ./start.sh ./stop.sh
  fi
}

# 检查项目状态
check_status() {
  if [ -f ".pid" ]; then
    PID=$(cat .pid)
    if ps -p $PID > /dev/null; then
      echo "项目正在运行中，进程ID: $PID"
      return 0
    else
      echo "项目未运行 (PID文件存在但进程不存在)"
      return 1
    fi
  else
    # 尝试查找可能的Next.js进程（开发或生产环境）
    NEXT_PID=$(ps aux | grep "next" | grep -v grep | awk '{print $2}')
    
    if [ -n "$NEXT_PID" ]; then
      echo "项目正在运行中，进程ID: $NEXT_PID (未通过控制脚本启动)"
      return 0
    else
      echo "项目未运行"
      return 1
    fi
  fi
}

# 主函数
main() {
  # 检查脚本文件
  check_scripts
  
  # 解析命令
  COMMAND=$1
  shift
  
  # 解析选项
  INSTALL_FLAG=""
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -i|--install)
        INSTALL_FLAG="--install"
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      *)
        echo "错误: 未知选项 $1"
        show_help
        exit 1
        ;;
    esac
  done
  
  # 执行命令
  case "$COMMAND" in
    start)
      ./start.sh $INSTALL_FLAG
      ;;
    stop)
      ./stop.sh
      ;;
    restart)
      ./stop.sh
      echo "正在重启项目..."
      sleep 2
      ./start.sh $INSTALL_FLAG
      ;;
    status)
      check_status
      ;;
    *)
      echo "错误: 未知命令 '$COMMAND'"
      show_help
      exit 1
      ;;
  esac
}

# 如果没有参数，显示帮助信息
if [ $# -eq 0 ]; then
  show_help
  exit 0
fi

# 执行主函数
main "$@"
