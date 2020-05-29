#!/usr/bin/env bash
set -euo pipefail

# for data in joined

mkdir -p data/stage2
# cat './data/joined/1' | head -n 100 |
stage2() {
	rg -v '([=\[\]@]|MKV|\d{3,4} ?x ?\d{3,4})' < $1 |
		rg -v '^\d+\.\d+' | rg -v '^\d+ \)' |
		sd '\([^\)]{1,60}\)' ' ' | sd '\{[^\}]{1,60}\}' ' ' |
		sed 's/\.\.\.$/./' | sd -s '...' ' ' |
		rg -v --ignore-case '^(korekta|tłumaczenie|przekład|napis|synchro)' |
		sd -s "Goa ' uld" 'Goauld' | # Stargate thing, common in suffixes
		sd -s "D ' jar" 'Djar' |     # Startrek sthing
		sd " ' (a|ego|s|em|owi|m|u|t|emu|ów|re|c|go|ie|ve|iem|n|ra|y|i|iego|d|owie|uid|ca|e|nie|to|ami)" '$1' |
		sd " ' (cie|tac|ę|am|mu|w|la|an|na|ach|ai|ą|sa|ri|im|al|dib|or)" '$1' |
		sd " ' (on|in|ch|o|il|my|om|ha|bo|l|kay|dum|iemu|mon|owy|ana|auc|onn|you|ma|er|cowi|bout|ta|taca|out|ka|reem|ow|owa|ala)" '$1' |
		sd " ' (ora|ową|ti|ciem|owej|sy|afo|at|chaim|ahu|cem|owych)" '$1' |
		sd " ' (ski|aime|cho|nar|nac|ki|ech|pea|lar|inem|so|kiem|kraps|sha|skim|ką)" '$1' >$2
}

export -f stage2 #probably not necessary

for file in ./data/joined/*;do
    sem -j 7 stage2 $file ${file/joined/stage2}
done
