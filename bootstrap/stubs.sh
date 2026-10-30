#!/usr/bin/env bash
# Keep ~/.zshrc and ~/.bashrc as real files that source the repo. Installers append
# to these files, so their additions stay on this machine and never dirty the repo.

set -e

DOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
MARKER="# dot-managed"

# Back up files that the link step replaces.
backup="$HOME/.dot-backup-$(date +%F)"
for file in .gitconfig .config/ghostty/config .config/jj/config.toml .config/git/ignore; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        mkdir -p "$backup/$(dirname "$file")"
        cp -n "$HOME/$file" "$backup/$file"
    fi
done

ensure_line() {
    local file=$1 line=$2
    if [ -L "$file" ]; then
        rm "$file"
    fi
    if grep -qF "$MARKER" "$file" 2> /dev/null; then
        local tmp
        tmp=$(mktemp)
        awk -v marker="$MARKER" -v line="$line" 'index($0, marker) { print line; next } { print }' "$file" > "$tmp"
        cat "$tmp" > "$file"
        rm "$tmp"
    else
        printf '%s\n' "$line" >> "$file"
    fi
}

ensure_line "$HOME/.zshrc" "export DOT_DIR=\"$DOT_DIR\"; source \"\$DOT_DIR/zsh/zshrc\" $MARKER"
ensure_line "$HOME/.bashrc" "export DOT_DIR=\"$DOT_DIR\"; . \"\$DOT_DIR/bash/bashrc\" $MARKER"

if ! grep -qs '\.bashrc' "$HOME/.bash_profile"; then
    printf '%s\n' '[ -f ~/.bashrc ] && . ~/.bashrc' >> "$HOME/.bash_profile"
fi
