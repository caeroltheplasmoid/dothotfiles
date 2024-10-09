#!/bin/python

import os 
import subprocess


# This script change colors light <-> dark 
# Especially, for:
# - GTK theme 
# - Sway theme 
# - waybar theme 
# ALSO: I didn't change QT theme, cause my qt follows for gtk configuration


SWAY_CURRENT_COLOR_CONF="/home/astrocat/.config/sway/colors/current-theme.conf"
SWAY_LIGHT_COLOR_CONF="$HOME/.config/sway/colors/light-theme.conf"
SWAY_DARK_COLOR_CONF="$HOME/.config/sway/colors/dark-theme.conf"

WAYBAR_COLOR_CONF="/home/astrocat/.config/waybar/style.css"
WAYBAR_REL_LIGHT_CONF="./light-style.css"
WAYBAR_REL_DARK_CONF="./dark-style.css"

ROFI_COLOR_CONF="/home/astrocat/.config/rofi/config.rasi"
ROFI_LIGHT_THEME="/home/astrocat/.config/rofi/themes/rounded-light.rasi"
ROFI_DARK_THEME="/home/astrocat/.config/rofi/themes/rounded-dark.rasi"

FOOT_COLOR_CONF="/home/astrocat/.config/foot/foot.ini"
FOOT_LIGHT_THEME="/home/astrocat/.config/foot/themes/default-light"
FOOT_DARK_THEME="/home/astrocat/.config/foot/themes/default-dark"




CURRENT_COLOR_SCHEME_PROC=os.popen("dconf read /org/gnome/desktop/interface/color-scheme")
CURRENT_COLOR_SCHEME = CURRENT_COLOR_SCHEME_PROC.read().rstrip()

print(CURRENT_COLOR_SCHEME)

def change_sway_colors(conf_file: str, colors_file: str):
    if not os.path.exists(conf_file):
        return
    with open(conf_file, 'w') as f:
        f.write(f"include {colors_file}") 

def change_waybar_colors(conf_file: str, style_file: str): 
    # if not os.path.exists(conf_file):
    #     return
    with open(conf_file, 'w') as f:
        f.write(f'@import "{style_file}";')

def change_foot_colors(conf_file: str, old_style_file: str, new_style_file: str):
    with open(conf_file, 'r') as f:
        data = f.read()

    data = data.replace(old_style_file, new_style_file)
    with open(conf_file, 'w') as f:
        f.write(data)
        
def change_rofi_colors(conf_file: str, style_file: str): 
    with open(conf_file, 'w') as f:
        f.write(f'@theme "{style_file}"')


if (CURRENT_COLOR_SCHEME == "'prefer-light'"):
    
    change_sway_colors(SWAY_CURRENT_COLOR_CONF, SWAY_DARK_COLOR_CONF)
    change_waybar_colors(WAYBAR_COLOR_CONF, WAYBAR_REL_DARK_CONF)
    os.popen(r""" dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'" """)
    os.popen(r""" dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'" """)
    change_foot_colors(FOOT_COLOR_CONF, FOOT_LIGHT_THEME, FOOT_DARK_THEME)
    change_rofi_colors(ROFI_COLOR_CONF, ROFI_DARK_THEME)
else:
    change_sway_colors(SWAY_CURRENT_COLOR_CONF, SWAY_LIGHT_COLOR_CONF)
    change_waybar_colors(WAYBAR_COLOR_CONF, WAYBAR_REL_LIGHT_CONF)
    os.popen(r"""dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-white'" """)
    os.popen(r"""dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'" """)
    change_foot_colors(FOOT_COLOR_CONF, FOOT_DARK_THEME, FOOT_LIGHT_THEME)
    change_rofi_colors(ROFI_COLOR_CONF, ROFI_LIGHT_THEME)


os.popen("swaymsg reload")

def cleanup():
    global CURRENT_COLOR_SCHEME_PROC
    CURRENT_COLOR_SCHEME_PROC.close()

cleanup()
