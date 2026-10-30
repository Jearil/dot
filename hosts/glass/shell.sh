# glass only. LM_STUDIO_API_KEY lives in ~/.zshrc, outside the repo.
export PATH="$PATH:$HOME/.lmstudio/bin:$HOME/.local/share/JetBrains/Toolbox/scripts"
export PATH="$HOME/.npm-global/bin:$PATH"
export LM_STUDIO_API_BASE=http://localhost:1234/v1

if [ -n "$ZSH_VERSION" ]; then
    [ -f "$HOME/Projects/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/Projects/google-cloud-sdk/path.zsh.inc"
    [ -f "$HOME/Projects/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/Projects/google-cloud-sdk/completion.zsh.inc"
fi
