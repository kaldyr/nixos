pid=`pgrep wl-screenrec`
status=$?

if [ $status != 0 ]
then
	wl-screenrec -g "$(slurp)" --audio --low-power=off -f $HOME/Videos/Screenrec/$(date +'%Y%m%d%H%M%S.mp4');
else
	pkill --signal SIGINT wl-screenrec
fi;
