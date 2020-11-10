.PHONY: install

install:
	mkdir -p ~/.ssh
	sops -d --extract '["public_key"]' --output ~/.ssh/seeker_rsa.pub secrets/ssh.yml
	sops -d --extract '["private_key"]' --output ~/.ssh/seeker_rsa.key secrets/ssh.yml
	chmod 600 ~/.ssh/seeker_rsa.*
	grep -q live.com ~/.ssh/config > /dev/null 2>&1 || cat config/ssh_client_config >> ~/.ssh/config
	mkdir -p ~/.kube
