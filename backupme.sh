#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_directory> <backup_directory>"
  exit 1
fi

source_directory="$1"
backup_directory="$2"

if [ ! -d "$source_directory" ]; then
  echo "Source directory not found: $source_directory"
  exit 1
fi

if [ ! -d "$backup_directory" ]; then
  mkdir -p "$backup_directory"
fi

backup_date=$(date +%Y%m%d)

backup_files() {
  local source="$1"
  local destination="$2"

  for item in "$source"/*; do
    if [ -f "$item" ]; then
      filename=$(basename "$item")
      cp "$item" "$destination/${filename}_${backup_date}.bac"
    elif [ -d "$item" ]; then
      dirname=$(basename "$item")
      mkdir -p "$destination/${dirname}_${backup_date}.bac"
      backup_files "$item" "$destination/${dirname}_${backup_date}.bac"
    fi
  done
}

backup_files "$source_directory" "$backup_directory"
echo "Backup completed successfully."

