#!/bin/sh
set -eu

mkdir -p data/stage1/

files=$(find ../all/data/stage3 -type f)
file_count="$(find ../all/data/stage3 -type f | wc -l)"
i=0

for file in $files; do
	cat "$file" >> data/stage1/dataset
	i=$((i + 1))
	progressbar $i "$file_count"
done

echo "Making it unique with quniq. Hope you have enough ram ;)"
quniq  < data/stage1/dataset  > data/stage1/unique
data/stage1/unique  data/stage1/dataset
