#!/usr/bin/env bash

notify() {
  notify-send -i $1 "Obsync" "$2"
}

obsync() {
  rclone sync ~/repos/pers/secondbrain/ koofrenc: --remove-empty-dirs &

  while [[ -n $(jobs -r) ]]; do
    notify $1 "$2"
    sleep 4
  done
}

obsync drive-harddisk "Synchronizing with cloud..."

notify face-wink "Synchronization successful."
