#!/bin/bash

mkdir -p ~/rom
cd ~/rom || exit 1

repo init -q --no-repo-verify --depth=1 -u git://github.com/AospExtended/manifest.git -b 11.x -g default,-device,-mips,-darwin,-notdefault

git clone https://github.com/Apon77Lab/android_.repo_local_manifests.git --depth 1 -b aex .repo/local_manifests

repo sync -c -q --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j 16
