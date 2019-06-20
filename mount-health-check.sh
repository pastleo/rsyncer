#!/bin/bash

cd $(dirname "$0")

echo "mount-health-check"
echo "==================="
date

if [ $(cat "./gdrive/.health-check" || echo "unhealthy") == "healthy" ]; then
  echo "mount point healthy"
  echo ""
  exit 0
fi

echo "re-mounting..."
fusermount -u ./gdrive
mkdir -p ./gdrive
google-drive-ocamlfuse -o nonempty,allow_other ./gdrive
echo "done"
echo ""
