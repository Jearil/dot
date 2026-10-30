# Aliases shared by bash and zsh.
command -v lsd >/dev/null 2>&1 && alias ls="lsd --group-dirs first"
command -v btop >/dev/null 2>&1 && alias top="btop"
alias rmorig="find . -name '*.orig' -exec rm -rf {} +"
alias tmux="tmux -2"
