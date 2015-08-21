# This is a bash library for a set functions and variables
# that is used regularly
#
# To use this library just include this line in your bash script:
#
# [ -e /usr/local/lib/nubis/nubis-lib.sh ] && . /usr/local/lib/nubis/nubis-lib.sh || exit 1

# Source the consul connection details from the metadata api
eval `curl -s -fq http://169.254.169.254/latest/user-data`

# Check to see if NUBIS_MIGRATE was set in userdata. If not we exit quietly.
if [ ${NUBIS_MIGRATE:-0} == '0' ]; then
    exit 0
fi

# Set up the consul url
CONSUL="http://localhost:8500/v1/kv/${NUBIS_STACK}/${NUBIS_ENVIRONMENT}/config"

# Some handy variables here
INSTANCE_ID=$(curl -s -fq http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_IP=$(curl -s -fq http://169.254.169.254/latest/meta-data/local-ipv4)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq '.region' -r)

# Some bash functions

# Yellow colored echo
# usage: echo_yellow "message"
function echo_yellow {
    echo -e "\033[0;33m$1\033[0m"
}

# Red colored echo
# usage: echo_red "message"
function echo_red {
    echo -e "\033[0;31m$1\033[0m"
}

# Green colored echo
# usage: echo_green "Message"
function echo_green {
    echo -e "\033[0;32m$1\033[0m"
}

# Send message to log
# usage: logmsg migrate "This is a log message"
function logmsg {

    if [ -z "$1" ] || [ -z "$2" ]; then echo "Usage: $FUNCNAME [log tag] [log message]"; exit 1; fi
    local tag=$1
    local msg=$2

    LOGGER_BIN='/usr/bin/logger'

    # Set up the logger command if the binary is installed
    if [ ! -x $LOGGER_BIN ]; then
        echo "ERROR: 'logger' binary not found - Aborting"
        echo "ERROR: '$BASH_SOURCE' Line: '$LINENO'"
        exit 2
    else
        $LOGGER_BIN --stderr --priority local7.info --tag "${tag}" "${msg}"
    fi
}

# Checks to see if consul is up and running
# usage: consul_up
function consul_up {

    # We run early, so we need to account for Consul's startup time, unfortunately, magic isn't
    # always free
    CONSUL_UP=-1
    COUNT=0
    while [ "$CONSUL_UP" != "0" ]; do
        if [ ${COUNT} == "6" ]; then
            logmsg migrate "ERROR: Timeout while attempting to connect to consul."
            exit 1
        fi
        QUERY=`curl -s ${CONSUL}?raw=1`
        CONSUL_UP=$?

        if [ "$QUERY" != "" ]; then
            CONSUL_UP=-2
        fi

        if [ "$CONSUL_UP" != "0" ]; then
            logmsg migrate "Consul not ready yet ($CONSUL_UP). Sleeping 10 seconds before retrying..."
            sleep 10
            COUNT=${COUNT}+1
        fi
    done
}

# Checks to see if if the consul key is up on consul
# usage: consul_key_up "keyname"
function consul_key_up {

    if [ -z "$1" ]; then echo "Usage: $FUNCNAME [consul key]"; exit 1; fi
    local consul_key=$1

    # Grab the variables from consul
    #+ If this is a new stack we need to wait for the values to be placed in consul
    #+ We will test the first and sleep with a timeout
    KEYS_UP=-1
    COUNT=0
    while [ "$KEYS_UP" != "0" ]; do
        # Try for 20 minutes (30 seconds * 20160 attempts = 604800 seconds / 60 seconds / 60 minutes / 12 hours = 7 days)
        if [ ${COUNT} == "20160" ]; then
            logmsg migrate "ERROR: Timeout while waiting for keys to be populated in consul."
            exit 1
        fi
        QUERY=$(curl -s ${CONSUL}/${consul_key}?raw=1)

        if [ "$QUERY" == "" ]; then
            logmsg migrate "Keys not ready yet. Sleeping 30 seconds before retrying..."
            sleep 30
            COUNT=${COUNT}+1
        else
            logmsg migrate "Key ${consul_key} is ready"
            KEYS_UP=0
        fi
    done
}

# check pre-reqs
hash jq 2>/dev/null || echo_red { "please install jq to use this build tool. https://github.com/stedolan/jq"; exit 1; }
hash aws 2>/dev/null || echo_red { "please install the aws cli api to use this build tool. https://aws.amazon.com/cli/"; exit 1; }
hash curl 2>/dev/null || echo_red { "please install curl"; exit 1; }
