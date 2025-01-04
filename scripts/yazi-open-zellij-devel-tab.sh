#!/run/current-system/sw/bin/bash
cd $1
tabname=''${PWD##*/}
if [ ''${PWD} == "/nix/config" ]; then
	tabname='NixOS'
fi
zellij --layout dev
sleep 0.1
zellij action move-focus left
zellij action move-focus down
zellij action write-chars "++"
zellij action move-focus up
zellij action write-chars ".\\"
zellij action move-focus right
zellij action rename-tab "$tabname"
kill -s SIGQUIT $PPID
