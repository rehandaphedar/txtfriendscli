#!/usr/bin/env bash

# I wrote a simple bash script that allows you to view people's friend.txt files.
# https://github.com/Asost

if [ $# -eq 0 ]
then
	echo "No arguments provided. Please input a URL (e.x. example.com)"
	exit 1
fi

while getopts "m:s::h" opt
do
	case $opt in
		m) menu=${OPTARG};;
		s) site=${OPTARG};;
		h) helpPrompt=true;;
	esac
done
shift $((OPTIND - 1))

if [ $helpPrompt ]
then
	echo "Usage: ./txtfriendscli.sh [-s siteURL] [-m menu] [-h]
	-h Print usage and basic information
	-s The website url without https:// or the trailing /friends.txt (just the domain)
	-m The menu you would like to use. Default is fzy but other options include: whiptail, dialog, dmenu, and rofi"
	exit 0
fi

if [[ $site = "" ]]
then
	site=$1
fi

echo "Press the escape button in the search bar menu to quit"

while :
do	
	echo "Choose a friend from $site"

	prompt="Choose friend"
	case $menu in
		fzy) res=$(curl -s https://$site/friends.txt | fzy);;
		rofi) res=$(curl -s https://$site/friends.txt | rofi -p "$prompt" -dmenu);;
		dmenu) res=$(curl -s https://$site/friends.txt | dmenu -p "$prompt");;
		whiptail|dialog) myarray=($(curl -s https://$site/friends.txt)); input=$($menu --title 'Friends.txt' --menu "$prompt" 25 78 15 $(paste <(printf "%s\n" "$(seq -s "," 1 1 ${#myarray[@]})" | sed -e $'s/,/\\\n/g') <(printf "%s\n" "${myarray[@]}") | sed 's/\t/ /') 3>&1 1>&2 2>&3); exitStat=$?; res=${myarray[$input-1]};;
		*) res=$(curl -s https://$site/friends.txt | fzy);;
	esac

	if [[ $? -ne 0 ]] || [[ $res = "q" ]] || [[ $exitStat -ne 0 ]]
	then
		break
	fi

	curl -s -I https://$res/friends.txt | grep -i -q "text/plain"
	if [[ $? -ne 0 ]] || [[ "$(curl -s -I https://$res/friends.txt | head -n 1|cut -d$' ' -f2)" -ne 200 ]]
	then
		echo "$res has no friends"
		continue
	fi

	site=$res
done
