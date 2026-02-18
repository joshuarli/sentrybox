# sentrybox

sentry in a lima vm with tools for claude to use it (currently scoped to backend testing only)

the idea is to bring up reproducible and ephemeral sentry dev environment VM(s) locally, so a locally authorized claude can login and do work

user ssh credentials are forwarded to the VM so the VM itself can push PRs; no need to download commit patchsets onto a local checkout


## todo

- multiple VMs
- example prompt -> skill /sentrybox-task
- basic profiling of 2 VMs working on the same test pollution task


## setup

```
ssh-add ~/.ssh/sentry-github

# make sure colima is not running

make build

make ssh  # for local iteration on the VM
```


## example prompt

```
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
```
