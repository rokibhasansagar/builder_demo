#!/bin/bash

# Increase swap space from 4GB to 13GB
# Usage: `_set_swap 13G`

swap_file=/mnt/swapfile
swap_file_size="${1}"
sudo swapoff $swap_file
sudo rm -f $swap_file
sudo fallocate -l $swap_file_size $swap_file
sudo chmod 600 $swap_file
sudo mkswap $swap_file
sudo swapon $swap_file
sudo swapon --show
