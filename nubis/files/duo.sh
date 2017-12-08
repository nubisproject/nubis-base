#!/bin/bash
# We run this to configure sshd_config with puppet and bounce the service
# its split out here because we were running into puppet memory allocation errors
# when it tries to bounce sshd so this gets to live here now

OS=$(lsb_release --id --short)

SSH_SERVICE="ssh"
if [ "${OS}" == "CentOS" ]; then
    SSH_SERVICE="sshd"
fi

puppet apply /etc/duo/duo_sshd_config_runtime.pp && systemctl restart "${SSH_SERVICE}"
