#!/bin/bash

shopt -s nullglob
declare -a jsons
jsons=(*.output) # ${jsons[@]} now contains the list of files to concatenate
echo '[' > stops.json
if [ ${#jsons[@]} -gt 0 ]; then # if the list is not empty
  cat "${jsons[0]}" >> stops.json # concatenate the first file to the stops...
  unset jsons[0]                     # and remove it from the list
  for f in "${jsons[@]}"; do         # iterate over the rest
      echo "," >>stops.json
      cat "$f" >>stops.json
  done
fi
echo ']' >>stops.json             # complete the stops
