#!/bin/bash
set -eu

mkdir -p data/stage3
stage3() {
	rg -v '^\s*\d+\s*\)' <"$1" |
		rg -v -i '^\s*(i+|iv|vi*|x+i*|)(\.\))' |
		sd -s '{' '(' | sd -s '}' ')' | sd -s '[' '(' | sd -s ']' ')' |
		sd '\([^\)]{1,90}\)' ' ' | # remove in parens
		sd '(\d+)r\.?' '$1 r.' |   # fix year
		sd '(m.in.|m in.|m. in|m. in.)' 'm.in.' >"$2"
}

export -f stage3
for file in ./data/stage2/*; do
	echo "processing $file"
	sem -j 7 stage3 "$file" "$(echo "$file" | sed 's/stage2/stage3/')"
done
