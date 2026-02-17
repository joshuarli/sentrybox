#!/bin/sh

# since we already have a reproducible environment we
# don't need devenv anymore and can just do this

cd ~/code/sentry
uv sync --frozen --inexact --active
pre-commit install --install-hooks -f
python3 -m tools.fast_editable --path .
sentry init --dev
devservices up --mode backend-ci

# not necessary for running pytest
# devservices up --mode migrations
# make apply-migrations
