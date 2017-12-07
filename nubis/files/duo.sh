#!/bin/bash
# We run this to configure sshd_config with puppet and bounce the service
# its split out here because we were running into puppet memory allocation errors
# when it tries to bounce sshd so this gets to live here now

OS=$(lsb_release --id | awk '{print $3}')

case "${OS}" in
    Ubuntu)
        SSH_SERVICE="ssh"
    ;;
    CentOS)
        SSH_SERVICE="sshd"
    ;;
    *)
        # If not supported we just assume ssh service is just ssh
        SSH_SERVICE="ssh"
    ;;
esac

puppet apply /etc/duo/duo_sshd_config_runtime.pp && systemctl restart "${SSH_SERVICE}"
