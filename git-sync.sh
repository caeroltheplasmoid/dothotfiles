#!/bin/bash

# Specify the .config folders to create submodules for
CONFIG_FOLDERS=( "/home/astrocat/.config/gtk-4.0" "/home/astrocat/.config/sway" "/home/astrocat/.config/swaylock" "/home/astrocat/.config/rofi" "/home/astrocat/.config/waybar")
REMOTE_REPO_URL="git@github.com:caeroltheplasmoid/dothotfiles.git"
DATE_TIME=$(date +"%Y-%m-%d_%H-%M-%S")
CURRENT_DIR=$(pwd)


if [ ! -d ".git" ]; then
  echo "Error: The current folder is not a git repository."
  echo "Initializing git folder";
  git init 
  git remote add origin ${REMOTE_REPO_URL};
fi

# dummy check
git remote remove origin;
git remote add origin ${REMOTE_REPO_URL};

git branch -m main
git add . 
git commit -m "BACKUP | FULL | $DATE_TIME"


for folder in "${CONFIG_FOLDERS[@]}"; do 
  folderName=$(basename "$folder")
  echo "$folder $folderName"
  if [ ! -d "$folder/.git" ]; then
      # Create a new git repository for the submodule
      cd "$folder"
      git init "$folder"
      git -C "$folder" add .
      git -C "$folder" remote add origin "$REMOTE_REPO_URL"
      git -C "$folder" commit -m "Initial commit for $folder submodule"
      git -C "$folder" branch -m "$folderName" 
      git push --force -u origin "$folderName"
  fi
  cd "$CURRENT_DIR"
  # git submodule add --force "$folder" "$folderName" 
  git -c protocol.file.allow=always submodule add --force -b "$folderName" "$REMOTE_REPO_URL" "$folderName" 
  git -c protocol.file.allow=always submodule update --remote "$folderName"

done

git branch -m main
# git pull

git commit -m "BACKUP | FINAL | $DATE_TIME"

git push origin main
