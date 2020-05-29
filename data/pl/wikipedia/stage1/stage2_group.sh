#!/usr/bin/env bash
set -euo pipefail

# mkdir -p data/final_batch
# mkdir -p data/final_batch_definition

# split_files=data/final_batch_definition/split_files

# test -s $split_files || \
#     ls ./data/split > $split_files

# all_files=$(wc -l < $split_files)
# splits=25
# lines_per_batch=$((all_files / splits))

cd data/final_batch_definition/
# split -l $lines_per_batch split_files
# rm split_files

i=0
for fn in *; do
    echo "$i Done"
    i=$((i + 1))
	cat $fn | xargs -I {} sh -c "cat ../split/{} >> ../final_batch/$i"
done
