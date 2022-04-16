#!/bin/sh

last_char(){
	str=$1
	i=$((${#str}-1))
	echo ${str:$i:1}
}

get_user(){
	user="$(whoami)"
	echo "$user"
}

get_hostname(){
	hostname="$(hostnamectl hostname)"
	echo "$hostname"
}

get_os(){
	os_release="$(head -n 1 /etc/os-release | sed 's/NAME=//g' | sed 's/"//g')"
	echo "$os_release"
}

get_uptime(){
	uptime="$(uptime -p | sed 's/up //g')"
	echo "$uptime"
}

get_kernel(){
	kernel="$(uname -r)"
	echo "$kernel"
}

get_shell(){
	shell="$(echo $SHELL)"
	echo "$shell"

}

get_network(){
	network="$(nmcli device status | grep "wifi " | awk '{printf $4"\n"}')"
	echo "$network"
}

get_mpd(){
	if [ "$(pgrep "mpDris2")" != "" ]; then
		status="$(playerctl --player=mpd status)"
	        mpd="$(playerctl --player=mpd metadata --format "{{ artist }} - {{ title }}")"

        	case "$status" in
        	        Stopped)
        	                suffix="(stopped)"
        	        ;;
        	        Paused)
        	                suffix="(paused)"
        	        ;;
      	  	esac

        	char="$(echo $mpd | wc -m)"
        	suffix_char="$(echo $suffix | wc -m)"
        	limit="$((61 - $suffix_char))"

        	if [ "$(($char + $suffix_char))" -gt "$limit" ]; then
                	mpd="$(echo "$mpd" | cut -c -$limit)"
                	mpd="${mpd}..."
        	fi

        	mpd="${mpd} ${suffix}"

		echo "$mpd"
	else
		echo "mpd or mpdris2 closed"
	fi
}

main(){
	p="\033[35m"
	b="\033[1m\033[34m"
	g="\033[1m\033[32m"
	rs="\033[0m"

	echo -e ""
	echo -e "$b    ) )     $p$(get_user)$rs@$p$(get_hostname)$rs"
	echo -e "$b   ( (      "$p"os:$rs     $(get_os)$rs"
	echo -e "$g ........   "$p"kernel:$rs $(get_kernel)$rs"
	echo -e "$g |      |]  "$p"up:$rs     $(get_uptime)$rs"
	echo -e "$g \      /   "$p"net:$rs    $(get_network)$rs"
	echo -e "$g  '____'    "$p"mpd:$rs    $(get_mpd)$rs"
	echo -e ""
}

main
