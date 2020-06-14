#!/bin/sh
set -euo

out=data/stage2
out_def=data/stage2_def

mkdir -p "$out"
mkdir -p "$out_def"

split_files=$out_def/split_index
ls ./data/out/ | shuf >$split_files

all_files=$(wc -l <$split_files)
splits=140
lines_per_batch=$((all_files / splits))

cd $out_def
split -l $lines_per_batch split_index
rm split_index

i=0
for fn in *; do
	echo "$i Done"
	i=$((i + 1))
	cat "$fn" | xargs -I {} sh -c "cat ../out/{} >> ../stage2/$i"
done
