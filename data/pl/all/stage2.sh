#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/stage2/{sub,wiki,ppc}
stage2(){
    awk '{if(length <= 400) print}' < $1 |
        python ./enchant_filter.py removed.txt > $2
}


export -f stage2
files=$(find data/stage1 -type f)
max_count=$(echo "$files" | wc -l)

count=0
for file in $files; do
	replaced="$(echo "$file" | sed 's/\/stage1\//\/stage2\//')"
	sem -j 7 stage2 "$file" "$replaced"
    count=$((count + 1))
    progressbar $count "$max_count"
done
echo ""
echo "Waiting for last tasks"
sem --wait
echo "Done"
