#!/usr/bin/env bash
set -euo pipefail


mkdir -p data/joined
mkdir -p data/joined_definition

split_files=data/joined_definition/split_index
ls ./data/input/ > $split_files

all_files=$(wc -l < $split_files)
splits=140
lines_per_batch=$((all_files / splits))

cd data/joined_definition/
split -l $lines_per_batch split_index
rm split_index

i=0
for fn in *; do
    echo "$i Done"
    i=$((i + 1))
	cat $fn | xargs -I {} sh -c "cat ../input/{} >> ../joined/$i"
done
