#!/usr/bin/env bash

FILE_PATHS=(
  "~/.zshrc"
  "~/.oh-my-zsh/custom/"
  "~/.config/Code - Insiders/User/settings.json"
  "~/.config/Code/User/settings.json"
  "~/code_workspaces/"
)

CUR_PATH="$(pwd)"
BACKUP_PATH="$CUR_PATH/backup/"

[ "$1" = "--restore" ] && echo "RESTORING FILES..."

backup_dir () {
  # $1 complete origin path
  # $2 Complete destination path
  destination_dir="$2"
  create_parent_directories_if_not_exist "$destination_dir"
  destination_dir="$(dirname "$2")"
  echo "COPYING DIRECTORY..."
  echo backup_dir EXECUTING cp -r "$1" "$destination_dir"
  cp -r "$1" "$destination_dir"
}

create_parent_directories_if_not_exist () {
  if [ ! -e "$1" ]; then
    echo "Creating non-existent directory '$1'"
    mkdir -p "$1"
  fi
}

for f_path in "${FILE_PATHS[@]}"; do
  first_char="${f_path:0:1}"
  base_file_path="$f_path"
  abs_pc_path="$f_path"
  if [ "$first_char" = "~" ]; then
    base_file_path="${f_path:2}"
    abs_pc_path="$HOME/$base_file_path"
  fi
  if [ "$first_char" = "/" ]; then
    base_file_path="${f_path:1}"
  fi

  if [[ "$1" = "--restore" ]]; then
    ORIGIN_FILE="$BACKUP_PATH$base_file_path"
    DESTINATION_PATH="$abs_pc_path"
  else
    ORIGIN_FILE="$abs_pc_path"
    DESTINATION_PATH="$BACKUP_PATH$base_file_path"
  fi

  # if the path doesn't exist on the origin, then skip backup
  if [ ! -e "$ORIGIN_FILE" ]; then
    echo "PATH '$ORIGIN_FILE' does not exist! Skipping..."
    continue
  fi
  if [ -d "$ORIGIN_FILE" ]; then
    backup_dir "$ORIGIN_FILE" "$DESTINATION_PATH"
    continue
  fi
  create_parent_directories_if_not_exist "$(dirname "$DESTINATION_PATH")"
  echo "EXECUTING: cp \"$ORIGIN_FILE\" \"$DESTINATION_PATH\""
  cp "$ORIGIN_FILE" "$DESTINATION_PATH"
done
