# sentrybox

sentry in a lima vm

currently scoped to backend testing only

the idea is to bring up reproducible and ephemeral sentry dev environment VM(s) locally, so a locally authorized claude can login and do work

user ssh credentials are forwarded to the VM so the VM itself can push PRs; no need to download commit patchsets onto a local checkout


## setup

ssh-add ~/.ssh/sentry-github
make build
make ssh

TODO: define local skill

i discovered this test pollution which consistently fails:

`pytest tests/sentry/api/endpoints/test_system_options.py::SystemOptionsTest::test_put_self_hosted_superuser_access_allowed tests/sentry/web/frontend/test_oauth_authorize.py::OAuthAuthorizeCustomSchemeTest::test_code_flow_unauthenticated_custom_scheme`

to work on this i want you to work entirely within the VM:
- you can execute commands in the dev environment vm like so: `limactl shell --workdir=/tmp sentrybox /etc/sentrybox/bin/claude-shell -- bash -c 'echo $PWD'`
- fetch then checkout the sentry commit at `d70943f39292efc10116bf81853b5381893c5d33`
  - sentry is located at `/home/claude/code/sentry`
- run `uv sync --frozen --inexact --active && python3 -m tools.fast_editable --path .` to resync dependencies
- run that pytest command to reproduce the error
- figure out the fix
- create a new branch with your changes with highly descriptive commit messages
- pushing can be done with `git push --set-upstream origin BRANCH_NAME`


## todo

- setup-claude.sh needs to setup gitconfig
  - also need to clone sentry from forwarded ssh credentials


## setup notes

you can't have colima running at the same time,
weird stuff happens

limactl stop -f sentrybox; limactl delete sentrybox

limactl start --tty=false sentrybox.yml
# equivalent of:
# limactl create --name=sentrybox --tty=false sentrybox.yml
# limactl start sentrybox

# while it's starting (but after ssh is ready), you can view provisioning logs
limactl shell --workdir=/tmp sentrybox -- sudo tail -f /var/log/cloud-init-output.log

limactl shell --workdir=/tmp sentrybox /etc/sentrybox/bin/claude-shell

  This runs as the Lima user (who has sudo), opens the
  socket permissions, then switches to claude with
  SSH_AUTH_SOCK preserved.

run a command as `claude`:
limactl shell --workdir=/tmp sentrybox /etc/sentrybox/bin/claude-shell -- bash -c 'echo $PWD'

~

to iterate on this live, you can also have a separate `make ss`
open so you can `sudo apt ...` and do whatever you need
