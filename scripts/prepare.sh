#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
git submodule update --init kernel
expected=d9180b6f8c846232728d4060d918575e8af1426e
test "$(git -C kernel rev-parse HEAD)" = "$expected"
mkdir -p firmware/ath9k_htc
curl -fL https://gitlab.com/kernel-firmware/linux-firmware/-/raw/main/ath9k_htc/htc_9271-1.4.0.fw -o firmware/ath9k_htc/htc_9271-1.4.0.fw
echo '78f7d592a95b419a02fde7440f30c606fc31a871cf0ce150ced40d4857173eb0  firmware/ath9k_htc/htc_9271-1.4.0.fw' | sha256sum -c -
