#!/usr/bin/env bash
set -euo pipefail

#Make nodoc
mkdir -p data/split
if test -s data/nodoc; then
	mv data/nodoc data/split/nodoc
else
	rg -v '^<doc' <data/data >data/split/nodoc
fi

cd data/split
csplit nodoc '/</doc>/' '{*}' > /dev/null
echo "Splitted"
mv nodoc ..
cd ../..

# rm data/split/nodoc

echo "Deleting first line (</doc) in each document"
# damn, this is slow, maybe rg or tail -n +2?
ls data/split | xargs -I {} sed -i '1d' data/split/{}
echo "Done"

# Join into ~25 pacs  each 50m
