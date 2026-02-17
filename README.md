ssh-add ~/.ssh/sentry-github

you can't have colima running at the same time,
weird stuff happens

limactl stop -f sentrybox; limactl delete sentrybox

limactl start --tty=false sentrybox.yml
# equivalent of:
# limactl create --name=sentrybox --tty=false sentrybox.yml
# limactl start sentrybox

# while it's starting (but after ssh is ready), you can view provisioning logs
limactl shell --workdir=/tmp sentrybox -- sudo tail -f /var/log/cloud-init-output.log

limactl shell --workdir=/tmp sentrybox claude-shell

  This runs as the Lima user (who has sudo), opens the
  socket permissions, then switches to claude with
  SSH_AUTH_SOCK preserved.

to iterate on this live, you can also have a separate `make ss`
open so you can `sudo apt ...` and do whatever you need
