ssh-add ~/.ssh/sentry-github

you can't have colima running at the same time,
weird stuff happens

limactl stop -f sentrybox; limactl delete sentrybox

limactl start --tty=false sentrybox.yml

# while it's starting (but after ssh is ready), you can view provisioning logs
limactl shell sentrybox -- sudo tail -f /var/log/cloud-init-output.log

limactl shell sentrybox claude-shell

  This runs as the Lima user (who has sudo), opens the
  socket permissions, then switches to claude with
  SSH_AUTH_SOCK preserved.

to iterate on this live, you can also have a separate `limactl shell sentrybox`
open so you can `sudo apt ...` and do whatever you need


## TODO

+ sudo -iu claude bash install-devenv.sh
Installing dependencies...

this needs to say y by default


File "/home/claude/code/sentry/devenv/sync.py", line 135, in main
    cfg["node"][constants.SYSTEM_MACHINE],
    ~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/claude/.local/share/sentry-devenv/python/lib/python3.11/configparser.py", line 1273, in __getitem__
    raise KeyError(key)
KeyError: 'linux_aarch64'
