#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends build-essential clang gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi bc bison flex libssl-dev libelf-dev ca-certificates python3 kmod
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
cd /work/kernel
mkdir -p /work/out
cp /work/config/merlin-base.config /work/out/.config
scripts/kconfig/merge_config.sh -m -O /work/out /work/out/.config /work/config/usb-drivers.fragment
make O=/work/out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
for option in MAC80211 ATH9K_HTC USB_SERIAL_CP210X USB_SERIAL_CH341 USB_SERIAL_FTDI_SIO USB_ACM; do
  grep -qx "CONFIG_${option}=y" /work/out/.config
done
make -j2 O=/work/out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-gnu- Image.gz-dtb
