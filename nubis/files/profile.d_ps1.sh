if [ "$PS1" ]; then
  ACCOUNT=$(nubis-metadata NUBIS_ACCOUNT)
  REGION=$(nubis-region)
  ARENA=$(nubis-metadata NUBIS_ARENA)
  PROJECT=$(nubis-metadata NUBIS_PROJECT)
  PURPOSE=$(nubis-metadata NUBIS_PURPOSE)
  ENVIRONMENT=$(nubis-metadata NUBIS_ENVIRONMENT)

  if [ "$ENVIRONMENT" != "" ]; then
    ARENA="$ARENA/$ENVIRONMENT"
  fi

  if [ "$PURPOSE" != "" ]; then
    PROJECT="$PROJECT.$PURPOSE"
  fi

  PS1="[\u@$ACCOUNT/$REGION/$ARENA {$PROJECT} \W]\$ "
fi
