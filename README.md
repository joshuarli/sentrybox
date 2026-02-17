# sentrybox

sentry in a lima vm

currently scoped to backend testing only

the idea is to bring up reproducible and ephemeral sentry dev environment VM(s) locally, so a locally authorized claude can login and do work

user ssh credentials are forwarded to the VM so the VM itself can push PRs; no need to download commit patchsets onto a local checkout


## setup

ssh-add ~/.ssh/sentry-github
make build


## example prompt

i discovered this test pollution which consistently fails on sentry @ 407f35c12da97a1be02b7289251ffd5133e5099f:

`pytest tests/sentry/api/endpoints/test_system_options.py::SystemOptionsTest::test_put_self_hosted_superuser_access_allowed tests/sentry/web/frontend/test_oauth_authorize.py::OAuthAuthorizeCustomSchemeTest::test_code_flow_unauthenticated_custom_scheme`

to work on this i want you to work entirely within the VM:
- you MUST ONLY execute commands in the dev environment vm by prefixing every command with: `LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper`
  - the working directory for these commands is inside a sentry checkout in the VM at `/home/claude/code/sentry`
- fetch then checkout the sentry commit at `407f35c12da97a1be02b7289251ffd5133e5099f`
  - for example: `LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper 'git fetch origin 407f35c12da97a1be02b7289251ffd5133e5099f'`
- run `LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper 'uv sync --frozen --inexact --active' && LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper 'python3 -m tools.fast_editable --path .'` to resync dependencies
- run that pytest command to reproduce the error
- figure out the fix
- create a new branch with your changes with highly descriptive commit messages
- pushing can be done with `LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper 'git push --set-upstream origin BRANCH_NAME'`


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

~

to iterate on this live, you can also have a separate `make ss`
open so you can `sudo apt ...` and do whatever you need
