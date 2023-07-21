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

checkhealth(){
  $1 >>/dev/null
  if [ $? == "127" ]; then
    echo -e "${RED_COLOR}false${RES}"
  else
    echo -e "${GREEN_COLOR}true${RES}"
  fi
}

ch_c(){
  if [ -e "./config.json" ]; then
    echo -e "${GREEN_COLOR}true${RES}"
  else
    echo -e "${RED_COLOR}false${RES}"
  fi
}

checkhealth1="$(checkhealth adb)"
checkhealth2="$(checkhealth dialog)"
checkhealth3="$(checkhealth "python -h")"
checkhealth4="$(ch_c)"

menu_main() {
  echo -e "${CYAN_COLOR}1${RES} ${GREEN_COLOR}${RES} connect device"
  echo -e "${CYAN_COLOR}2${RES} ${BLUE_COLOR}${RES} commands\n"
  echo -e "${BLUE_COLOR}#${RES} checkhealth:"
  echo -e "android-tools:${checkhealth1}"
  echo -e "dialog:${checkhealth2}"
  echo -e "python3:${checkhealth3}"
  echo -e "configruation:${checkhealth4}"
}

# TODO: Connect ip address
network() {
  local line=$(grep -o '"ip": "[^"]*' config.json | grep -o '[^"]*$' | wc -l)
  # if [ -e "./config.json" ] && [[ "$(grep -o 'ip' ./config.json)" == "ip" ]] && [[ "$(grep -o 'passwd' ./config.json)" == "passwd" ]] && [[ "$(grep -o 'port' ./config.json)" == "port" ]]; then
  #   connect_ip=127.0.0.1
  #   read -p "Port:" network_port
  #   read -p "Passwd:" network_passwd
  #   adb connect "$connect_ip":"$network_port" "$network_passwd"
  if [ -e "./config.json" ] && [[ "$(grep -o 'ip' ./config.json)" == "ip" ]] && [[ "$(grep -o 'port' ./config.json)" == "port" ]]; then
    connect_ip=$(grep -o '"ip": "[^"]*' config.json | grep -o '[^"]*$')
    connect_port=$(grep -o '"port": "[^"]*' config.json | grep -o '[^"]*$')
    adb connect "$connect_ip":"$connect_port"
  elif [ -e "./config.json" ] && [[ "$(grep -o 'ip' ./config.json)" == "ip" ]]; then
    connect_ip=$(grep -o '"ip": "[^"]*' config.json | grep -o '[^"]*$')
    adb connect "$connect_ip"
  elif [[ $line -gt 1 ]]; then
    connect_ip=$(grep -o '"ip": "[^"]*' config.json | grep -o '[^"]*$')
    for ipaddress in $connect_ip; do
      adb connect "$ipaddress"
    done
  else
    read -rp "Input ip address:" connect_ip
    adb connect "$connect_ip"
  fi
  # return_message
}

# TODO: Connect ip address
push_files() {
  read -rp "Input push files:" push_file
  if [ -e "./config.json" ] && [[ "$(grep -o 'save-path' ./config.json)" == "save-path" ]]; then
    # connect_ip="$(cat ./config.json | grep -o -E "[0-9.]+")"
    save_path=$(grep -o '"save-path": "[^"]*' config.json | grep -o '[^"]*$')
  else
    read -rp "Input save path:" save_path
  fi
  adb push "$push_file" "$save_path"
  # return_message
}

input_1() {
  # echo ""
  echo -e "${BLUE_COLOR}lazyadb > main${RES}"
  read -rp "(lazyadb) " input1
  # echo ""
}


adb_install() {
  python3 ./install-apk.py
}

# PERF: Debug
adb_shell() {
  adb shell exit >> /dev/null 2>&1
  if [ $? == 1 ]; then
    network
    adb shell
  else
    adb shell
  fi
}

# NOTE:ascil logo
print_text() {
  echo -e "${BLUE_COLOR}                      Z ┏━┓${RES}"
  echo -e "${BLUE_COLOR}╻  ┏━┓╺━┓╻ ╻┏━┓╺┳┓┏┓ z  ┃ ┃${RES}"
  echo -e "${BLUE_COLOR}┃  ┣━┫┏━┛┗┳┛┣━┫ ┃┃┣┻┓   ┃ ┃${RES}"
  echo -e "${BLUE_COLOR}┗━╸╹ ╹┗━╸ ╹ ╹ ╹╺┻┛┗━┛   ┗━┛${RES}"
  echo -e ""
  echo -e "${GREEN_COLOR}Lazyadb v1.0-release ${RES}" 
  echo -e "${GREEN_COLOR} g? ${RES}help"
  echo -e "${GREEN_COLOR} exit ${RES}exit"
  echo -e "${GREEN_COLOR} m ${RES}menu"
}

clear
# greetings
# termux_check
while true; do
  input_1
  case $input1 in
    1)
      network
      ;;
    exit)
      exit 0
      ;;
    m)
      menu_main
      ;;
    2)
      adb_shell
      ;;
    3)
      push_files
      ;;
    4)
      adb_install
      ;;
    g\?)
      print_text
      ;;
    *)
      echo -e "${RED_COLOR}[󰅙lazyadb]${RES}"
      ;;
  esac
  echo " "
done
