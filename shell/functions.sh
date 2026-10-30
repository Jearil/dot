# Functions shared by bash and zsh. _dot_notify comes from os/<os>.sh.

# Run a command and notify when it finishes.
b() {
    "$@"
    _dot_notify "Command Complete"
}

_dot_hms() {
    printf '%02d:%02d:%02d' $(($1 / 3600)) $(($1 % 3600 / 60)) $(($1 % 60))
}

countdown() {
    local end=$(($(date +%s) + $1))
    while [ "$end" -ge "$(date +%s)" ]; do
        printf '%s\r' "$(_dot_hms $((end - $(date +%s))))"
        sleep 0.1
    done
    _dot_notify "Timer Complete"
}

stopwatch() {
    local start
    start=$(date +%s)
    while true; do
        printf '%s\r' "$(_dot_hms $(($(date +%s) - start)))"
        sleep 0.1
    done
}
