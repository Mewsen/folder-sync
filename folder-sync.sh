#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <path1> <path2> ..."
  exit 1
fi

main_path=""
backup_paths=()

for path in "$@"; do
  real_path=$(realpath "$path")
  
  if [ ! -d "$real_path" ]; then
    echo "Error: '$real_path' is not a valid directory."
    continue
  fi

  sync_file="$real_path/.folder-sync"
  if [ ! -f "$sync_file" ]; then
    echo "Warning: '$real_path' does not contain a .folder-sync file. Skipping."
    continue
  fi

  role=$(<"$sync_file")
  case "$role" in
    main)
      if [ -n "$main_path" ]; then
        echo "Error: More than one main directory found ('$main_path' and '$real_path')."
        exit 2
      fi
      main_path="$real_path"
      ;;
    backup)
      backup_paths+=("$real_path")
      ;;
    *)
      echo "Warning: Unknown role '$role' in $sync_file. Must be 'main' or 'backup'. Skipping."
      ;;
  esac
done

if [ -z "$main_path" ]; then
  echo "Error: No main directory found."
  exit 3
fi

if [ "${#backup_paths[@]}" -eq 0 ]; then
  echo "Error: No backup directories found."
  exit 4
fi

for backup in "${backup_paths[@]}"; do
  echo "Syncing from '$main_path/' to '$backup/' ..."
  rsync -av --delete --exclude=".folder-sync" "$main_path/" "$backup/"
done

echo "Sync complete."
