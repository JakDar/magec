#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/stage2
stage2() {
	rg -v '^\s*\d+\s*\)' < "$1" |
		rg -v -i '^\s*(i+|iv|vi*|x+i*|)(\.\))' |
		sd -s '{' '(' | sd -s '}' ')' | sd -s '[' '(' | sd -s ']' ')' |
		sd '\([^\)]{1,90}\)' ' ' | # remove in parens
        sd '(\d+)r\.?' '$1 r.' | # fix year
        sd '(m.in.|m in.|m. in|m. in.)' 'm.in.' > "$2"
}

export -f stage2
for file in ./data/out/*; do
	sem -j 7 stage2 "$file" "${file/out/stage2}"
done
