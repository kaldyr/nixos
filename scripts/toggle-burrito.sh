export STATUS_FILE="$XDG_RUNTIME_DIR/burrito.status"
ADDR=$(hyprctl clients -j | jq --raw-output '.[] | select (.class=="Burrito") | .address')
echo $ADDR

enable_burrito() {
    printf "true" >"$STATUS_FILE"
    notify-send -u normal "Focus Burrito"
	 sh -c "hyprctl dispatch setprop address:$ADDR nofocus off"
}

disable_burrito() {
    printf "false" >"$STATUS_FILE"
    notify-send -u normal "Nofocus Burrito"
	 sh -c "hyprctl dispatch setprop address:$ADDR nofocus on"
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_burrito
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disable_burrito
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enable_burrito
  fi
fi
