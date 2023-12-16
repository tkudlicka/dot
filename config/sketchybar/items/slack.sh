#!/usr/bin/env sh

slack_template=(
#   drawing=off
#   background.corner_radius=12
#   padding_left=7
#   padding_right=7
#   icon.background.height=2
#   icon.background.y_offset=-12
)


sketchybar  --add   item slack right \
            --set   slack \
                    update_freq=180 \
                    script="$PLUGIN_DIR/slack.sh" \
                    background.padding_left=7  \
           --set slack.template "${slack_template[@]}"
           --subscribe slack system_woke