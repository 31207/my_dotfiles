#!/bin/sh

# 主题文件的路径
dir="$HOME/.config/rofi/powermenu/" # 主题文件夹
theme="mytheme"                     # 默认主题

# 部分提示信息：
host="$USER"                        # 主机名称
uptime="$(uptime -p | sed -e 's/up //g')" # 登陆时长

# 选项列表
lock="$(echo -e '\uf023 锁屏')"      # 锁屏
reboot="$(echo -e '\uf021 重启')"    # 重启
shutdown="$(echo -e '\uf011 关机')"  # 关机
hibernate="$(echo -e '\uf186 休眠')" # 休眠
suspend="$(echo -e '\uf0f4 挂起')"   # 挂起
logout="$(echo -e '\uf08b 登出')"    # 登出
yes="$(echo -e '\uf058 同意')"       # 同意
no="$(echo -e '\uf057 取消')"        # 取消

# 部分符号
user="$(echo -e '\uf007')"  # 用户符号
clock="$(echo -e '\uf017')" # 钟表符号


run_powermenu() {
  echo -e "$lock\n$reboot\n$shutdown\n$hibernate\n$suspend\n$logout" | powermenu_cmd
}

powermenu_cmd() {
  rofi -dmenu \
    -p "$user $USER@$host" \
    -mesg "$clock 已运行: $uptime" \
    -theme ${dir}/${theme}.rasi
}

run_confirm() {
  echo -e "$yes\n$no" | confirm_cmd
}

confirm_cmd() {
  rofi -theme-str "window {location: center; anchor: center; fullscreen: false; width: 460px;}" \
    -theme-str "mainbox {orientation: vertical; children: [ "message", "listview" ];}" \
    -theme-str "listview {columns: 2; lines: 1;}" \
    -theme-str "element-text {horizontal-align: 0.5;}" \
    -theme-str "textbox {horizontal-align: 0.5;}" \
    -dmenu \
    -p "确认界面" \
    -mesg "你确定吗？" \
    -theme ${dir}/${theme}.rasi
}


# 关机操作
shutdown_action() {
  isconfirm="$(run_confirm)"
  if [[ $isconfirm == $yes ]]; then
    systemctl poweroff
  fi
}

# 重启操作
reboot_action() {
  isconfirm="$(run_confirm)"
  if [[ $isconfirm == $yes ]]; then
    systemctl reboot
  fi
}

# 休眠操作
hibernate_action() {
  isconfirm="$(run_confirm)"
  if [[ $isconfirm == $yes ]]; then
    systemctl hibernate
  fi
}

# 挂起操作
suspend_action() {
  isconfirm="$(run_confirm)"
  if [[ $isconfirm == $yes ]]; then
    mpc -q pause
    amixer set Master mute
    systemctl suspend
  fi
}

# 登出操作
logout_action() {
  isconfirm="$(run_confirm)"
  if [[ $isconfirm == $yes ]]; then
    dwm_pid="$(pidof -s dwm)"
    if [[ -n $dwm_pid ]]; then
      kill -TERM $dwm_pid
    fi
  fi
}

# 锁屏操作
lock_action() {
  if [[ -x '/usr/bin/i3lock' ]]; then
    i3lock
  fi
}

# 主函数
main() {
  chosen="$(run_powermenu)"
  case $chosen in
    $shutdown) shutdown_action ;;
    $reboot) reboot_action ;;
    $hibernate) hibernate_action ;;
    $suspend) suspend_action ;;
    $logout) logout_action ;;
    $lock) lock_action ;;
  esac
}

main &
