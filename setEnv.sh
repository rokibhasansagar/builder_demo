#!/bin/bash

ROOTDIR=${PWD}

echo "::group::Apt setup"
sudo apt-fast update -qy
sudo apt-fast upgrade -qy
sudo apt-fast install -qy --no-install-recommends --no-install-suggests \
  lsb-core linux-headers-$(uname -r) python3-dev python-is-python3 xzdec zstd libzstd-dev lib32z1-dev build-essential libc6-dev-i386 gcc-multilib g++-multilib ninja-build clang cmake libxml2-utils xsltproc expat re2c lib32ncurses5-dev bc libreadline-gplv2-dev gawk xterm rename schedtool gperf rclone
sudo apt-get clean -y && sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
echo "::endgroup::"

echo "::group::Latest make and ccache setup"
mkdir -p /tmp/env
cd /tmp/env || exit 1
curl -sL https://ftp.gnu.org/gnu/make/make-4.3.tar.gz -O
tar xzf make-4.3.tar.gz && cd make-*/
./configure && bash ./build.sh 1>/dev/null && sudo install ./make /usr/bin/make

cd /tmp/env || exit 1
git clone -q https://github.com/ccache/ccache.git && cd ccache && git checkout -q v4.2
mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..
make -j8 && sudo make install
echo "::endgroup::"

cd ${ROOTDIR} || exit 1
rm -rf /tmp/env

echo "::group::Ccache config"
mkdir -p /home/runner/.config/ccache
cat << EOC > /home/runner/.config/ccache/ccache.conf
cache_dir =  /home/runner/.cache/ccache
compression = true
compression_level = 6
max_size = 5G
recache = true
EOC

ccache -p
echo "::endgroup::"
