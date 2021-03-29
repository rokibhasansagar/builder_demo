#!/bin/bash

mkdir -p ~/rom
cd ~/rom || exit 1

# Download Previously Compressed Archive
_download_precompressed_files() {
  aria2c -c -x16 -s16 "https://gdrive.phantomzone.workers.dev/0:/norepo_files/aex11_mido.tzst"
  time tar --use-compress-program="zstd -T0 --long=31" -xf aex11_mido.tzst
  rm -rf aex11_mido.tzst
}
# Sync Fresh Files From Git Server
_repo_sync_fresh_files() {
  repo init -q --no-repo-verify --depth=1 -u git://github.com/AospExtended/manifest.git -b 11.x -g default,-device,-mips,-darwin,-notdefault
  git clone https://github.com/Apon77Lab/android_.repo_local_manifests.git --depth 1 -b aex .repo/local_manifests
  time repo sync -c -q --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j 16
}

if [[ $# = 0 || "${1}" = "fresh" ]]; then
  _repo_sync_fresh_files
elif [[ "${1}" = "old" ]]; then
  _download_precompressed_files
fi
