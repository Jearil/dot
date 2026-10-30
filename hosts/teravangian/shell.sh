# teravangian only.
export PATH="$HOME/.opencode/bin:$PATH:/mnt/Games/Android/flutter/bin"

# Coppermind daemon token, only on hosts that run the daemon
[ -f "$HOME/.secrets/coppermind.env" ] && . "$HOME/.secrets/coppermind.env"

# flutter web/headless E2E uses chromium
export CHROME_EXECUTABLE=/usr/bin/chromium-browser
