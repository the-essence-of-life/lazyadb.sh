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
  echo -e "# checkhealth:"
  echo -e "android-tools:${checkhealth1}"
  echo -e "dialog:${checkhealth2}"
  echo -e "python3:${checkhealth3}"
  echo -e "configruation:${checkhealth4}"
}

# TODO: Connect ip address
wifi_connect() {
  if [ -e "./config.json" ]; then
    connect_ip="$(cat ./config.json | grep -o -E "[0-9.]+")"
  else
    read -rp "Input ip address:" connect_ip
  fi
  adb connect "$connect_ip"
  # return_message
}

input_1() {
  # echo ""
  echo -e "${BLUE_COLOR}lazyadb > main${RES}"
  read -rp "(lazyadb) " input1
  # echo ""
}


# PERF: Debug
adb_shell() {
  adb shell
  wifi_connect
}

# NOTE:ascil logo
print_text() {
  echo -e "${BLUE_COLOR}                      Z ┏━┓${RES} ${GREEN_COLOR}Lazyadb v1.0-release ${RES}"
  echo -e "${BLUE_COLOR}╻  ┏━┓╺━┓╻ ╻┏━┓╺┳┓┏┓ z  ┃ ┃${RES} ${GREEN_COLOR} g? ${RES}help"
  echo -e "${BLUE_COLOR}┃  ┣━┫┏━┛┗┳┛┣━┫ ┃┃┣┻┓   ┃ ┃${RES} ${GREEN_COLOR} (e)xit ${RES}exit"
  echo -e "${BLUE_COLOR}┗━╸╹ ╹┗━╸ ╹ ╹ ╹╺┻┛┗━┛   ┗━┛${RES} ${GREEN_COLOR} m ${RES}menu"
}

clear
# greetings
# termux_check
while true; do
  input_1
  case $input1 in
    1)
      wifi_connect
      ;;
    # b)
    #   menu_2
    #   ;;
    e|exit)
      exit 0
      ;;
    m)
      menu_main
      ;;
    # t)
    #   pull_apk
    #   ;;
    2)
      adb_shell
      ;;
    # l)
    #   lazy_am
    #   ;;
    # f)
    #   ;;
    g\?)
      print_text
      ;;
    *)
      echo -e "${RED_COLOR}[󰅙lazyadb]${RES}"
      ;;
  esac
  echo " "
done
