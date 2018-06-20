#!/bin/bash

PI_ADDRESS="pi1.local"

ccgreen="\033[0;34m"

exclude="/\.[^/]*$"

echo "Watching for changes. Quit anytime with Ctrl-C."
fswatch -0 -r -l 1 ./ --exclude="$exclude" | while read -d "" event ; do
  event=$(echo $event | sed '/\.git\//d')
  echo $event > .tmp_files

  if [[ ! -z $event ]]; then
    echo -en "${ccgreen}" `date` "${ccend}\"$event\" changed. Synchronizing... "
    rsync -avzr -q --include-from=.tmp_files --delete --cvs-exclude \
      --exclude=".git" \
      --exclude="devinit.sh" \
      --exclude=".build" \
       ./ ${PI_ADDRESS}:rc-car-server/
    echo "done."
  fi
done
rm -rf .tmp_files
