#!/bin/bash

google-chrome-stable --headless --no-sandbox --disable-gpu --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-cdp --disable-dev-shm-usage 2>/dev/null &

sleep 2

exec /usr/bin/openclaw gateway
