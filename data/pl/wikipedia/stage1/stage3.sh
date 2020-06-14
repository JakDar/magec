#!/usr/bin/env bash
set -euo pipefail

# Normalize things
mkdir -p data/stage3

stage3() {
	sd '(\d+)r\.?' '$1 r.' <$1 | # fix year
		rg -v '^x+\d+$' |
		../../../tools/moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l pl >$2
}

export -f stage3
for file in ./data/final_batch/*; do
	echo "processing $file"
	sem -j 7 stage3 "$file" "$(echo "$file" | sed 's/final_batch/stage3/')"
done

sem --wait
