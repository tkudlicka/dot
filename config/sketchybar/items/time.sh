time=(
  update_freq=1
  script="$PLUGIN_DIR/time.sh"
  click_script="$POPUP_CLICK_SCRIPT"
  icon.font="$FONT:Regular:19.0"
)

sketchybar --add item time right \
  --set time "${time[@]}" \
  --subscribe time system_woke
