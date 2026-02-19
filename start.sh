#!/bin/bash

if [ ! -f ~/.openclaw/openclaw.json ]; then
    echo "No configuration found. Running initial setup..."
    exec openclaw onboard
fi

exec /usr/bin/openclaw gateway
