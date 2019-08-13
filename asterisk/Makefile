build:
	@clear
	@docker rmi -f asterisk 2>&1 1> /dev/null; exit 0
	@docker build \
		--tag asterisk \
		-f docker/Dockerfile .

run:
	@clear
	@docker run \
		--rm \
		--net=host \
		--name asterisk \
		--hostname asterisk.lab.net \
		--volume "/var/lib/asterisk:/var/lib/asterisk" \
		--volume "/etc/asterisk:/etc/asterisk" \
		--volume "/var/spool/asterisk:/var/spool/asterisk" \
		--volume "/var/run/asterisk/asterisk.ctl:/var/run/asterisk/asterisk.ctl" \
		-it asterisk /usr/sbin/asterisk -vvvdddf -T -W -U asterisk -p -n

shell:
	@clear
	@docker run -it asterisk /bin/bash
