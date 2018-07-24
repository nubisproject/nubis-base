if [ "$PS1" ] && [ "$(nubis-metadata status)" == 'ready' ]; then
    if nubis-metadata NUBIS_ACCOUNT > /dev/null 2>&1; then
        ACCOUNT=$(nubis-metadata NUBIS_ACCOUNT)
    fi
    if nubis-metadata INSTANCE_IDENTITY_REGION > /dev/null 2>&1; then
        REGION=$(nubis-metadata INSTANCE_IDENTITY_REGION)
    fi
    if nubis-metadata NUBIS_ARENA > /dev/null 2>&1; then
        ARENA=$(nubis-metadata NUBIS_ARENA)
    fi
    if nubis-metadata NUBIS_PROJECT > /dev/null 2>&1; then
        PROJECT=$(nubis-metadata NUBIS_PROJECT)
    fi
    if nubis-metadata NUBIS_PURPOSE > /dev/null 2>&1; then
        PURPOSE=$(nubis-metadata NUBIS_PURPOSE)
    fi
    if nubis-metadata NUBIS_ENVIRONMENT > /dev/null 2>&1; then
        ENVIRONMENT=$(nubis-metadata NUBIS_ENVIRONMENT)
    fi

    if [ "${ENVIRONMENT}" != "" ]; then
        ARENA="${ARENA}/${ENVIRONMENT}"
    fi

    if [ "${PURPOSE}" != "" ]; then
        PROJECT="${PROJECT}.${PURPOSE}"
    fi

    PS1="[\u@${ACCOUNT:-account}/${REGION:-region}/${ARENA:-arena} {$PROJECT} \W]\$ "
elif [ "$PS1" ]; then
    PS1="[\u@\h \W]\$ "
fi
