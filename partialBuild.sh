#!/bin/bash

cd ~/rom || exit 1

export ALLOW_MISSING_DEPENDENCIES=true

echo "::group::Lunch for ${partialTarget}"
. build/envsetup.sh
lunch aosp_mido-user
echo "::endgroup::"

rm -rf .repo 2>/dev/null || true

echo "::group::Disk Space"
df -hlT
echo "::endgroup::"

echo "::group::Ccache Size before build"
du -sh ~/.cache/ccache 2>/dev/null || true
echo ":endgroup::"

echo "::group::Build Process"
_ccache_stats() {
  sleep 5m
  while true; do echo -e "CCACHE_STAT\n"; ccache -s; echo -e "\n"; top -b -i -n 1; sleep 5m; done
}

_ccache_stats 2>/dev/null &

{
  make -j4 ${1} || mmma ${1}
} || true
kill %1
echo "::endgroup::"

echo "::group::Ccache Size before build"
du -sh ~/.cache/ccache 2>/dev/null || true
echo ":endgroup::"

exit
