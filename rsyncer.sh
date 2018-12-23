#!/bin/bash

# Usage: path/to/this/script.sh src_path patch_path des_path [log_path]
# For crontab that runs every Monday AM 1:10:
# 10 1 * * 1 path/to/this/script.sh /mnt/usr /mnt/gdrive/usrpatch /mnt/gdrive/usr [log_name]

# This will:
# 1. update 'patch_path' -> 'src_path'
# 2. sync 'src_path' -> 'des_path' (delete enabled)
# 3. sync folder structure 'src_path' -> 'patch_path' (delete enabled)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" -eq "0"  ]; then
  src_path="$DIR/src"
  patch_path="$DIR/patch"
  des_path="$DIR/des"
else
  src_path="$1"
  patch_path="$2"
  des_path="$3"
fi
if [ -z "$4" ]; then
  log_path="$DIR/log/rsyncer.log"
else
  log_path="$4"
fi

for path in "$src_path" "$patch_path" "$des_path"
do
  if [ -z "$path" ]; then
    echo "Usage: path/to/this/script.sh [src_path patch_path des_path] [log_path]" >&2
    exit 1
  fi
done

mv "$log_path" "${log_path}.last" 2> /dev/null
set -e

main() {
  echo '<< rsyncer >>'

  echo "src_path: $src_path"
  echo "patch_path: $patch_path"
  echo "des_path: $des_path"
  echo "log_path: $log_path"

  for path in "$src_path" "$patch_path" "$des_path"
  do
    while [ ! -d "$path" ]
    do
      echo "Waiting for directory $path"
      sleep 5
    done
  done

  echo '========================================'
  date
  echo '>> patch -> src (update):'
  echo rsync -rtWLKhv --inplace --size-only --prune-empty-dirs --include='/.gitignore' --exclude '.*/' --exclude '.*' "$patch_path/" "$src_path/"
  rsync -rtWLKhv --inplace --size-only --prune-empty-dirs --include='/.gitignore' --exclude '.*/' --exclude '.*' "$patch_path/" "$src_path/"
  echo ''

  echo '========================================'
  date
  echo '>> src -> des (sync):'
  echo rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' --exclude '.*/' --exclude '.*' "$src_path/" "$des_path/"
  rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' --exclude '.*/' --exclude '.*' "$src_path/" "$des_path/"
  echo ''

  echo '========================================'
  date
  echo '>> src -> patch (blank folder structure):'
  echo rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' -f'+ */' -f'- *' --exclude '.*/' --exclude '.*' "$src_path/" "$patch_path/"
  rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' -f'+ */' -f'- *' --exclude '.*/' --exclude '.*' "$src_path/" "$patch_path/"
  echo ''

  echo '>> Done!'
}

main | tee "$log_path"
