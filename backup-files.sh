#!/usr/bin/env bash

FILE_PATHS=(
  "~/.zshrc"
  "~/.oh-my-zsh/custom/"
  "~/.config/Code - Insiders/User/settings.json"
  "~/.config/Code/User/settings.json"
)

CUR_PATH=$(pwd)

if [[ "$1" = "--restore" ]]; then
  echo "RESTORING FILES..."
else
  for f_path in "${FILE_PATHS[@]}"; do
    echo "$f_path"
    first_char="${f_path:0:1}"
    base_file_path="$f_path"
    complete_path="$base_file_path"
    if [ "$first_char" = "~" ]; then
      base_file_path="${f_path:2}"
      complete_path="$HOME/$base_file_path"
    fi
    rm -rf "$CUR_PATH/backup/$base_file_path"
    echo cp "$complete_path" "$CUR_PATH/backup/$base_file_path"
    cp -r "$complete_path" "$CUR_PATH/backup/$base_file_path"
  done
fi
