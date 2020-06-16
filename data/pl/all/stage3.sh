#!/usr/bin/env bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/stage3/{sub,wiki,ppc}
stage3() {
	awk '{if(10 <= length || length <= 150) print}' <$1 |
		python word_tokenize.py >$2
}

export -f stage3
files=$(find data/stage2 -type f)
max_count=$(echo "$files" | wc -l)

count=0
echo "Started at $(date)"
for file in $files; do
	replaced="$(echo "$file" | sed 's/\/stage2\//\/stage3\//')"
	sem -j 7 stage3 "$file" "$replaced"
	count=$((count + 1))
	progressbar $count "$max_count"
done
echo ""
echo "Waiting for last tasks"
sem --wait
echo "Done"
