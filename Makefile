build:
	tmux new-window -n sentrybox \; \
		send-keys 'limactl stop -f sentrybox; limactl delete sentrybox; rm -rf ~/.lima/sentrybox; limactl start --tty=false sentrybox.yml' Enter \; \
		split-window -v \; \
		send-keys 'sleep 10 && limactl shell --workdir=/tmp sentrybox -- sudo tail -f /var/log/cloud-init-output.log' Enter

ssh:
	LIMA_VM_NAME=sentrybox ./lima-ssh-wrapper
