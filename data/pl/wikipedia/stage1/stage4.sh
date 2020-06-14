#!/bin/bash
set -e

mkdir -p data/stage4

for file in ./data/stage3/*; do
	echo "processing $file"
	replaced="$(echo "$file" | sed 's/stage3/stage4/')"
	sem -j 7 ./sent_tokenize.py $file "$replaced"
done

sem --wait
echo "done"
