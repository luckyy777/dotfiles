play_pause(){
	status="$(mpc status | sed -n 2p | awk '{printf $1"\n"}')"
	if [ "$status" = "[playing]" ]; then
		play_or_pause="pause"
	else
		play_or_pause="play"
	fi
	
	mpc $play_or_pause >> /dev/null
}

play_pause
