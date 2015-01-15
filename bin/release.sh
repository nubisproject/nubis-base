#!/bin/bash

umask 077
date=$(date)
id=${USER-root}@$(hostname)

usage(){
   echo "Usage: $0 -f <file> [-r] [-b]" 1>&2
   exit 1
}

while getopts "f:rb" o; do
   case "${o}" in
      f)
         file=$OPTARG
         ;;
      r)
         increment_release=1
         ;;
      *)
         usage
         ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$file" ]; then
   echo file blank
   usage
fi

if [ -f $file ]; then
   source $file

   if [ ${increment_release:-0} -eq 1 ]; then
      release=$(($release + 1))
      build=0
   else
      build=$(($build + 1))
   fi
else
   release=0
   build=1
fi

rm -f $file
cat << EOF > $file
release=$release
build=$build
EOF
