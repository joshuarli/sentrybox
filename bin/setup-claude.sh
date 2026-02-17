#!/bin/bash

cat > ~/.profile << EOF
export PATH='$HOME/code/sentry/.venv/bin:/etc/sentrybox/bin:$HOME/.local/bin:$PATH'
export VIRTUAL_ENV='$HOME/code/sentry/.venv'
EOF

git config --global user.name "sentrybox"
git config --global user.email "sentrybox@localhost"

curl -LsSf https://astral.sh/uv/0.10.3/install.sh | sh

git clone --filter=blob:none --single-branch --branch=master https://github.com/getsentry/sentry ~/code/sentry

# TODO: we can't clone over ssh yet at build-time
# but we need ssh uri for pushing with forwarded ssh credentials
git -C ~/code/sentry remote set-url origin git@github.com:getsentry/sentry.git
