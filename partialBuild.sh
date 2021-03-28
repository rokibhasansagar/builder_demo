#!/bin/bash

cd ~/rom || exit 1

export ALLOW_MISSING_DEPENDENCIES=true

echo "::group::Lunch for ${{ env.partialTarget }}"
. build/envsetup.sh
lunch aosp_mido-user
echo "::endgroup::"

rm -rf .repo

echo "::group::Disk Space"
df -hlT
echo "::endgroup::"

_ccache_stats() {
  sleep 1m
  while true; echo -e "CCACHE_STAT\n"; do ccache -s; echo -e "\n"; top -b -i -n 1; sleep 5m; done
}

_ccache_stats 2>/dev/null &
{
  make -j4 ${1} || mmma ${1}
} || exit 1
kill %1
exit
