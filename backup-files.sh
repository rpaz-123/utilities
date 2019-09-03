#!/usr/bin/env bash

FILE_PATHS=(
  "~/.zshrc"
  "~/.oh-my-zsh/custom/"
  "~/.config/Code - Insiders/User/settings.json"
  "~/.config/Code/User/settings.json"
)

CUR_PATH="$(pwd)"
BACKUP_PATH="$CUR_PATH/backup/"

create_directory () {
  echo "creating dir $1"
}

backup_dir () {
  destination_dir="$2"
  if [ -d "$2" ]; then
    destination_dir="$(dirname "$2")"
    echo "backup path already exists, copying to parent dir '$destination_dir'"
  fi
  echo "COPYING..."
  echo cp -r "$1" "$destination_dir"
  cp -r "$1" "$destination_dir"
}

if [[ "$1" = "--restore" ]]; then
  echo "RESTORING FILES..."
else
  for f_path in "${FILE_PATHS[@]}"; do
    first_char="${f_path:0:1}"
    base_file_path="$f_path"
    complete_path="$base_file_path"
    if [ "$first_char" = "~" ]; then
      base_file_path="${f_path:2}"
      complete_path="$HOME/$base_file_path"
    fi
    if [ "$first_char" = "/" ]; then
      base_file_path="${f_path:1}"
    fi
    # if the path doesn't exist on the computer, then skip backup
    if [ ! -e "$complete_path" ]; then
      echo "PATH '$complete_path' does not exist! Skipping..."
      continue
    fi
    if [ -d "$complete_path" ]; then
      backup_dir "$complete_path" "$BACKUP_PATH$base_file_path"
      continue
    fi
    echo cp "$complete_path" "$BACKUP_PATH$base_file_path"
  done
fi
