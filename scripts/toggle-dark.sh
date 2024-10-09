#!/bin/bash


# This script change colors light <-> dark 
# Especially, for:
# - GTK theme 
# - Sway theme 
# - waybar theme 
# ALSO: I didn't change QT theme, cause my qt follows for gtk configuration



SWAY_CURRENT_COLOR_CONF="$HOME/.config/sway/colors/current-theme.conf"
SWAY_LIGHT_COLOR_CONF="$HOME/.config/sway/colors/light-theme.conf"
SWAY_DARK_COLOR_CONF="$HOME/.config/sway/colors/dark-theme.conf"


CURRENT_COLOR_SCHEME=$(dconf read /org/gnome/desktop/interface/color-scheme)
echo $CURRENT_COLOR_SCHEME;

if [ "$CURRENT_COLOR_SCHEME" = "'prefer-light'" ]; then
  sed -i "s|$SWAY_CURRENT_COLOR_CONF|$SWAY_LIGHT_COLOR_CONF|g" "$SWAY_CURRENT_COLOR_CONF"

  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
  dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
else
  sed -i "s|sway_current_color_conf|sway_dark_color_conf|g" "$SWAY_CURRENT_COLOR_CONF"

  dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
  dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-white'"
fi
 


