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
EC2_AVAIL_ZONE=$(curl -s -fq http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

# Some bash functions

# Send message to log
# usage: logmsg migrate "This is a log message"
logmsg() {

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

# Print messages
# usage:    message_print CRITICAL "Unable to run script"
#           message_print OK "all good"
message_print(){
    local exit_after=0

    case "$1" in
        OK)
            code="0"
            color="0;32"
            ;;
        WARNING)
            code="1"
            color="0;33"
            ;;
        CRITICAL)
            code="2"
            color="1;31"
            exit_code=1
            ;;
    esac

    if [[ -t 1 ]]; then
        echo -e "\033[${color}m${2}\033[0m"
    else
        echo "${1}: ${2}"
    fi

    if [[ -n "$3" ]]; then
        echo
        echo "$3"
        echo
    fi

    if [[ $exit_code -gt 0 ]]; then
        exit $exit_code
    fi
}

# Checks to see if consul is up and running
# usage: consul_up
consul_up() {

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
# usage: key_up "keyname"
key_up() {

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

# Check pre-reqs
hash jq 2>/dev/null || message_print CRITICAL "Please install jq to use this build tool. https://github.com/stedolan/jq"
hash aws 2>/dev/null || message_print CRITICAL "Please install the AWS CLI API to use this build tool. https://aws.amazon.com/cli/"
hash curl 2>/dev/null || message_print CRITICAL "Please install curl"
