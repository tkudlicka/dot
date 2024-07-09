#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    space=$sid
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=4
    icon.padding_right=4
    padding_left=2
    padding_right=2
    icon.highlight_color=$DEFAULT
    background.color=$BACKGROUND_1
background.border_color=$DEFAULT
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done
