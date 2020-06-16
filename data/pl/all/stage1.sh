#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/stage1/{sub,wiki,ppc}
stage1() {
	../../tools/moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l pl <"$1" |
		sed -E 's/[^[:alnum:] ,\.\?\!]/ /Ig; s/ +/ /g' | # alphaa will alow for czech, arabic and so on
		rg -v '^\s*$' |
		sd '[0-9]' '1' >"$2" # replace all numbers to ones, keeping length
}

export -f stage1


files=$(find data -type f)
max_count=$(echo "$files" | wc -l)
BAR='########################################' # 40
EMPTY='                                        ' # 40
bar_size=$(echo $BAR| wc -c)


count=0
for file in $files; do
	replaced="$(echo "$file" | sed 's/\/in\//\/stage1\//')"
	sem -j 7 stage1 "$file" "$replaced"
    count=$((count + 1))
    i=$((count * bar_size / max_count))
    echo -ne "\r${BAR:0:$i}${EMPTY:$i:$bar_size} $count/$max_count" #bashisms
done
echo ""
echo "Waiting for last tasks"
sem --wait
echo "Done"
