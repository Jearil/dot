#!/usr/bin/env bash
# Copy starting configs for apps that rewrite their own config files. Existing files
# are left alone: linking these would dirty the repo whenever the app saves a setting.

DOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

seed() {
    if [ ! -e "$2" ]; then
        mkdir -p "$(dirname "$2")"
        cp "$DOT_DIR/$1" "$2"
    fi
}

seed config/btop/btop.conf "$HOME/.config/btop/btop.conf"

zed_dir="$HOME/.config/zed"
if [ -d "$HOME/.var/app/dev.zed.Zed" ]; then
    zed_dir="$HOME/.var/app/dev.zed.Zed/config/zed"
fi
seed config/zed/settings.json "$zed_dir/settings.json"
seed config/zed/keymap.json "$zed_dir/keymap.json"
