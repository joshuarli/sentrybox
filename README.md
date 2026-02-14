ssh-add ~/.ssh/sentry-github

limactl stop -f sentrybox; limactl delete sentrybox

limactl start --tty=false --log-level=debug sentrybox.yml

limactl shell sentrybox claude-shell

  This runs as the Lima user (who has sudo), opens the
  socket permissions, then switches to claude with
  SSH_AUTH_SOCK preserved.

to iterate on this live, you can also have a separate `limactl shell sentrybox`
open so you can `sudo apt ...` and do whatever you need


## TODO

File "/home/claude/code/sentry/devenv/sync.py", line 135, in main
    cfg["node"][constants.SYSTEM_MACHINE],
    ~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/claude/.local/share/sentry-devenv/python/lib/python3.11/configparser.py", line 1273, in __getitem__
    raise KeyError(key)
KeyError: 'linux_aarch64'
