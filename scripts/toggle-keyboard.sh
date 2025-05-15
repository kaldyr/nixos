export STATUS_FILE="$XDG_RUNTIME_DIR/keyboard.status"

enable_keyboard() {
    printf "true" >"$STATUS_FILE"
    notify-send -u normal "Enabling Keyboard"
    # hyprctl keyword '$LAPTOP_KB_ENABLED' "true" -r
	 sh -c "hyprctl keyword 'device[at-translated-set-2-keyboard]:enabled' 1"
	 sh -c "hyprctl keyword 'device[dll0b38:01-04f3:320f-touchpad]:enabled' 1"
}

disable_keyboard() {
    printf "false" >"$STATUS_FILE"
    notify-send -u normal "Disabling Keyboard"
	 # hyprctl keyword '$LAPTOP_KB_ENABLED' "false" -r
	 sh -c "hyprctl keyword 'device[at-translated-set-2-keyboard]:enabled' 0"
	 sh -c "hyprctl keyword 'device[dll0b38:01-04f3:320f-touchpad]:enabled' 0"
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_keyboard
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disable_keyboard
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enable_keyboard
  fi
fi
