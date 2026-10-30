#!/usr/bin/env bash
# Apply shared KDE settings. Config files aren't linked because KDE can replace them
# when it saves. Monitor layouts, panels and kwinrc stay per-machine.

set -e

if ! command -v plasma-apply-lookandfeel > /dev/null; then
    echo "KDE Plasma not found, skipping" >&2
    exit 0
fi

plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
