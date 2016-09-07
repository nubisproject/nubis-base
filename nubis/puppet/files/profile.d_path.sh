# For whatever reason amazon linux doesn't export the local paths
# So we take matters into our own hands
LOCALPATH="/usr/local/bin:/usr/local/sbin"
export PATH="$LOCALPATH:$PATH"
