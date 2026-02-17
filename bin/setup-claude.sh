#!/bin/bash

cat > ~/.profile << EOF
export PATH='$HOME/code/sentry/.venv/bin:/etc/sentrybox/bin:$HOME/.local/bin:$PATH'
export VIRTUAL_ENV='$HOME/code/sentry/.venv'
EOF

curl -LsSf https://astral.sh/uv/0.10.3/install.sh | sh

git clone --filter=blob:none --single-branch --branch=master https://github.com/getsentry/sentry ~/code/sentry
