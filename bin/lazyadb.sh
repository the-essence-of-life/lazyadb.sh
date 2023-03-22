#!/bin/bash

RED_COLOR='\e[1;31m'
GREEN_COLOR='\e[1;32m'
YELLOW_COLOR='\e[1;33m'
BLUE_COLOR='\e[1;34m'
PINK_COLOR='\e[1;35m'
CYAN_COLOR='\e[1;36m'
BG_COLOR='\e[1;47m'
HLW='\e[1;1m'
RES='\e[0m'
HL='\e[1m'

linux='/usr/etc'
termux='/data/data/com.termux/files/usr/etc'
a_lzc='/data/data/com.termux/files/usr'
l_lzc='/usr'

trap 'onCtrlC' INT
function onCtrlC () {
  exit 0
}

config_files() {
  if [[ "$(uname -a)" =~ "GNU" ]]; then
    mkdir -p ${linux}/lazyadb/bin ${linux}/lazyadb/conf
  elif [[ "$(uname -a)" =~ "Android" ]]; then
    mkdir -p ${termux}/lazyadb/bin ${termux}/lazyadb/conf
  fi
}

menu_main() {
  echo -e "${GREEN_COLOR}安装基本组件 (i)nstall${RES}"
  echo -e "${CYAN_COLOR}a${RES} ${GREEN_COLOR}${RES} 连接"
  echo -e "${CYAN_COLOR}b${RES} ${GREEN_COLOR}${RES} 管理软件"
  echo -e "${CYAN_COLOR}c${RES} ${YELLOW_COLOR}${RES} 文件管理"
  echo -e "${CYAN_COLOR}d${RES} ${BLUE_COLOR}${RES} 命令行"
  echo -e "${CYAN_COLOR}l${RES} ${RED_COLOR}${RES} 更多"
  echo -e "${CYAN_COLOR}f${RES} ${YELLOW_COLOR}${RES} 配置"
}

return_message() {	
  echo "如果显示"connect to xxx.xxx.xxx.xxx",就连接成功"
  echo "如果显示"failed to xxx.xxx.xxx.xxx",就连接失败"
}

# TODO: Connect ip address
wifi_connect() {
  read -rp "输入ip:" connect_ip
  adb connect "$connect_ip"
  return_message
}

# FIXME:无法一步到位！
pull_apk() {
  adb shell am mounitor
  read -rp "输入获取的包名:" apk_package
  adb shell pm path $apk_package
  read -rp "输入获取的路径:" apk_path
  echo "安装包会保存在当前目录下"
  # shellcheck disable=2086
  adb pull $apk_path $(pwd)
  progress
}

input_1() {
  echo ""
  echo -e "${BLUE_COLOR}lazyadb > main${RES}"
  read -rp "(lazyadb) " input1
}

# TAGS:后续调整
progress() {
  for ((i=0 ; $i<=100 ; i+=5)); do
    printf "进度条:[%-20s]%d%%\r" $b $i
    # 主要部分
    b=#$b
    sleep 1
  done
  echo
}

pull_apk() {
  read -rp "Input package name:" package_name
  read -rp "Input package safe path:" save_path
  adb shell pm path $package_name | cut -b 9-
  read -rp "Copy the path,and press enter:" apk_path
  adb pull "${apk_path}" ${save_path}
}

pull_files() {
  read -p "请选择要提取的文件,文件会保存在/storage/emulated/0/Download里" pullfile
  adb pull "$pullfile" $(pwd)/pullfiles
}

pull_more_files() {
  touch ./temp.txt
  ed -sp "Please input the file path:" temp.txt
  for i in IFS=cat ./temp.txt ; do
    adb pull $i /sdcard/Download/
  done
  rm -f ./temp.txt
}

push_files() {
  read -p "请粘贴要上传的文件路径:" pu
  adb push $pu /storage/emulated/0/Download
}

install_apks() {
  read -p "Apk path:" apk_path
  adb install $apk_path
}

set_connect_sucssess() {
  if [ $? -eq 1 ]; then
    echo -e "${RED_COLOR}重试中,请稍后~${RES}"
    adb connect "$connect_ip"
  fi
}

# PERF: Debug
adb_shell() {
  adb shell
  set_connect_sucssess
}

# termux_check() {
# if [[ "$(uname -a)" =~ "Android" ]]; then
# termux-toast "你的手机系统是安卓"
# fi
# }

input_text() {
  while true; do
    read -p "Input text:" text
    adb shell input text "$text"
    if (( ${text} == "exit" )); then
      break
    fi
  done
}

# NOTE:ascil logo
print_text() {
  echo -e "${BLUE_COLOR}                      Z ┏━┓${RES} ${GREEN_COLOR}Lazyadb v1.0-release ${RES}"
  echo -e "${BLUE_COLOR}╻  ┏━┓╺━┓╻ ╻┏━┓╺┳┓┏┓ z  ┃ ┃${RES} ${GREEN_COLOR} (h)elp ${RES}查看帮助"
  echo -e "${BLUE_COLOR}┃  ┣━┫┏━┛┗┳┛┣━┫ ┃┃┣┻┓   ┃ ┃${RES} ${GREEN_COLOR} (e)xit ${RES}退出软件"
  echo -e "${BLUE_COLOR}┗━╸╹ ╹┗━╸ ╹ ╹ ╹╺┻┛┗━┛   ┗━┛${RES} ${GREEN_COLOR} (m)enu ${RES}打开菜单"
}

debug() {
  adb >> /dev/null
  # shellcheck disable=2181
  if [ $? -eq 0 ]; then
    echo -e "${GREEN_COLOR}${RES} adb"
  elif [ $? -eq 1 ];then
    echo -e "${RED_COLOR}${RES} adb"
  fi
}

lazy_am() {
  if [[ "$(uname -a)" =~ "Android" ]]; then
    bash ${a_lzc}/etc/lazyadb/bin/am.sh
  else
    bash ${l_lzc}/etc/lazyadb/bin/am.sh
  fi
}

menu_2() {
  select choice in 安装软件 卸载软件 获取包名 提取安装包 打开软件 快速安装 批量提取文件 返回
  do
    PS3="请输入你要用的功能:"
    case "$choice" in
      安装软件)
        read -p "输入安装包路径:" apk_path
        adb install "$apk_path"
        ;;
      卸载软件)
        read -p "输入要卸载的软件包名:" apk_id
        adb uninstall "$apk_id"
        ;;
      获取包名)
        adb shell am mounitor
        ;;
      提取安装包)
        pull_apk
        ;;
      打开软件)
        read -p "Input apk name and start activity:" apk_name apk_activity
        adb shell am mounitor "${apk_name}"/${apk_activity}
        ;;
      快速安装)
        read -p "Input url:" url
        curl -# -O $url
        adb install $(pwd)/*.apk
        rm *.apk
        ;;
      批量提取文件)
        pull_more_files
        ;;
      返回)
        break
        ;;
      *)
        echo -e "${YELLOW_COLOR}[lazyadb]输入的信息有误,请重新输入！${RES}"
        ;;
    esac
  done
}

# 主体部分
clear
print_text
# greetings
# termux_check
while true; do
  input_1
  case $input1 in
    a)
      wifi_connect
      ;;
    b)
      menu_2
      ;;
    e|exit)
      echo "感谢您的使用"
      exit 0
      ;;
    m|menu)
      menu_main
      ;;
    t)
      pull_apk
      ;;
    d)
      adb_shell
      ;;
    l)
      lazy_am
      ;;
    f)
      ;;
    *)
      echo -e "${YELLOW_COLOR}[lazyadb]输入的信息有误,请重新输入！${RES}"
      ;;
  esac
done
