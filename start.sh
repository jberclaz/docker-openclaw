#!/bin/bash

if [ ! -f ~/.openclaw/openclaw.json ]; then
    echo "No configuration found. Running initial setup..."
    exec openclaw onboard
fi

google-chrome-stable --headless --no-sandbox --disable-gpu --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-cdp --disable-dev-shm-usage 2>/dev/null &

sleep 2

exec /usr/bin/openclaw gateway
