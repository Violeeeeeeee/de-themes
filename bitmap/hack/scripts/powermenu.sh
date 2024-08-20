#!/usr/bin/env bash

## Author  : Viole

dir="$HOME/.config/polybar/hack/scripts/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -no-config -theme $dir/powermenu.rasi"

# Options
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Confirmation
confirm_exit() {
	rofi -dmenu \
		-no-config \
		-i \
		-no-fixed-num-lines \
		-p "Are You Sure? : " \
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -no-config -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			qdbus org.kde.ksmserver /KSMServer logout 0 1 2
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
		else
			msg
		fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			qdbus org.kde.ksmserver /KSMServer logout 0 1 1
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
		else
			msg
		fi
        ;;
    $lock)
		qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			qdbus org.freedesktop.PowerManagement /org/freedesktop/PowerManagement Suspend
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
		else
			msg
		fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			qdbus org.kde.ksmserver /KSMServer logout 0 0 0
		elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
			exit 0
		else
			msg
		fi
        ;;
esac
