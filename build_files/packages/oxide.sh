#!/bin/bash

set -ouex pipefail

dnf5 install -y sudo sudo-rs uutils-coreutils
rm -rf /usr/local && mkdir -p /usr/local/bin/
ln -sf /usr/bin/sudo-rs /usr/local/bin/sudo

UUTILS_BIN_DIR="/usr/bin"
for bin_path in "$UUTILS_BIN_DIR"/uu_*; do
    name=$(basename "$bin_path" | sed 's/^uu_//')
    [[ "$name" == "[" ]] && continue
    ln -sf "$bin_path" "/usr/local/bin/$name"
done