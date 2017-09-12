#!/bin/bash

# Usage: path/to/this/script.sh
# For crontab that runs every Monday AM 1:10:
# 10 1 * * 1 path/to/this/script.sh

# This will:
# 1. update './patch' -> './src'
# 2. sync './src' -> './des' (delete enabled)
# 3. sync folder structure './src' -> './patch' (delete enabled)

# Place structure like this:
# ├── des
# │   └── usr -> things to be synced to
# ├── patch
# │   └── usr -> things to be applied to src and des
# └── src
#     └── usr -> things to be synced from

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
log_file="${DIR}/run.log"
mv "$log_file" "${log_file}.last"
set -e

echo '<< rsyncer >>' >> "$log_file"

echo '========================================' >> "$log_file"
date >> "$log_file"
echo '>> patch -> src (update):' >> "$log_file"
echo rsync -rtWLKhv --inplace --size-only --prune-empty-dirs --include='/.gitignore' --exclude '.*/' --exclude '.*' "${DIR}/patch/" "${DIR}/src/" >> "$log_file"
rsync -rtWLKhv --inplace --size-only --prune-empty-dirs --include='/.gitignore' --exclude '.*/' --exclude '.*' "${DIR}/patch/" "${DIR}/src/" >> "$log_file"
echo '' >> "$log_file"

echo '========================================' >> "$log_file"
date >> "$log_file"
echo '>> src -> des (sync):' >> "$log_file"
echo rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' --exclude '.*/' --exclude '.*' "${DIR}/src/" "${DIR}/des/" >> "$log_file"
rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' --exclude '.*/' --exclude '.*' "${DIR}/src/" "${DIR}/des/" >> "$log_file"
echo '' >> "$log_file"

echo '========================================' >> "$log_file"
date >> "$log_file"
echo '>> src -> patch (blank folder structure):' >> "$log_file"
echo rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' -f'+ */' -f'- *' --exclude '.*/' --exclude '.*' "${DIR}/src/" "${DIR}/patch/" >> "$log_file"
rsync -rtWLKhv --inplace --size-only --del --delete-excluded --include='/.gitignore' -f'+ */' -f'- *' --exclude '.*/' --exclude '.*' "${DIR}/src/" "${DIR}/patch/" >> "$log_file"
echo '' >> "$log_file"

echo '>> Done!' >> "$log_file"
