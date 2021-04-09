#!/bin/bash
set -xv

ccache_task="${1}"    # upload/download

CCache_URL="https://gdrive.phantomzone.workers.dev/0:/mido_ccache/ccache.tgz"

if [[ ${ccache_task} =~ upload ]]; then
  printf "Compressing ccache data...\n"
  ccache -s
  tar -I "pigz -k -3" -cf /home/runner/.cache/ccache.tgz /home/runner/.cache/ccache
  du -sh /home/runner/.cache/ccache.tgz
  printf "Setting up rclone...\n"
  mkdir -p /home/runner/.config/rclone
  echo "${RClone_Config}" > /home/runner/.config/rclone/rclone.conf
  rclone delete td:/mido_ccache/ccache.tgz 2>/dev/null || true
  rclone copy /home/runner/.cache/ccache.tgz td:/mido_ccache/ --progress
  rm -rf /home/runner/.cache/ccache.tgz
elif [[ ${ccache_task} =~ download ]]; then
  printf "Downloading previous ccache...\n"
  mkdir -p /home/runner/.cache/ccache
  cd /home/runner/.ccache
  aria2c -c -x16 -s16 "${CCache_URL}"
  tar -I "pigz" -xf ccache.tgz
  ls -lAog /home/runner/.cache/ccache
  ccache -s
  rm -rf /home/runner/.cache/ccache.tgz
fi

set +xv
