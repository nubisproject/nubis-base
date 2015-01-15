#!/bin/bash

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
   usage
fi

umask 077
if [ -f $file ]; then
   release=$(grep release $file | cut -d ':' -f 2 | cut -d '"' -f 2)
   build=$(grep build $file | cut -d ':' -f 2 | cut -d '"' -f 2)

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
{
  "release": "$release",
  "build": "$build",
}
EOF
