#!/usr/bin/env bash
# Stop early, with a useful message, if the install steps can't work.

missing=()
for tool in git curl make zsh vim python3; do
    command -v "$tool" > /dev/null || missing+=("$tool")
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "Missing required tools: ${missing[*]}" >&2
    if [ "$(uname)" = "Darwin" ]; then
        echo "Install them with: xcode-select --install" >&2
    else
        echo "Install them with: sudo dnf install ${missing[*]}" >&2
    fi
    exit 1
fi
