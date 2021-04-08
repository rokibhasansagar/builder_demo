#!/bin/bash

ccache_task="${1}"    # upload/download

CCache_URL="https://gdrive.phantomzone.workers.dev/0:/mido_ccache/ccache.tgz"

if [[ ${ccache_task} =~ upload ]]; then
  tar -I "pigz -k -2" -cf ~/.cache/ccache.tgz ~/.cache/ccache
  mkdir -p ~/.config/rclone
  echo "${RClone_Config}" > ~/.config/rclone/rclone.conf
  rclone delete td:/mido_ccache/ccache.tgz 2>/dev/null || true
  rclone copy ~/.cache/ccache.tgz td:/mido_ccache/ --progress
  rm -rf ~/.cache/ccache.tgz
elif [[ ${ccache_task} =~ download ]]; then
  mkdir -p ~/.cache/ccache
  cd ~/.ccache || exit 1
  aria2c -c -x16 -s16 "${CCache_URL}"
  tar -I "pigz" -xf ccache.tgz
  rm -rf ~/.cache/ccache.tgz
fi
