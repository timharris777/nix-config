#!/usr/bin/env bash
echo "$(whoami)"
if [ "$SENDER" = "aerospace_workspace_change" ] || [ "$SENDER" = "forced" ]; then
    # Get focused workspace if not passed in
    if [ "$FOCUSED_WORKSPACE" = "" ]; then
        FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"
    fi
    # Set focused workspace
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set $NAME background.drawing=on
    else
        sketchybar --set $NAME background.drawing=off
    fi
fi

if [ "$SENDER" = "display_change" ]; then
    # If monitor count changes reload
    if [ -f "$HOME/.config/sketchybar/data/display_count" ]; then
        PREVIOUS_DISPLAYS="$(cat ~/.config/sketchybar/data/display_count)"
    fi
    CURRENT_DISPLAYS="$(aerospace list-monitors | grep -c '')"
    if [ "$CURRENT_DISPLAYS" != "$PREVIOUS_DISPLAYS" ]; then
        sketchybar --reload
    fi
    mkdir -p ~/.config/sketchybar/data
    echo "$CURRENT_DISPLAYS" >~/.config/sketchybar/data/display_count
fi
