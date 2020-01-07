SRC_FILE=/home/owner/blob/data/nlp/wikipl/plwiki/plwiki
DST_DIR=./files


notag:
	mkdir -p $(DST_DIR)
	sd  '<doc id=.{2,100}?>' 'newdocument' < $(SRC_FILE) | sd '<.{2,100}?>' '' | rg -v '^\s*$$' | sort -u > $(DST_DIR)/notag.txt

moses-normalize:
	[ -f $(DST_DIR)/notag_moses.txt ] || ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl  -l pl < $(DST_DIR)/notag.txt | sort -u > $(DST_DIR)/notag_moses.txt

sent-tokenize:
	[ -f "$(DST_DIR)/notag_moses_sent.txt" ] || python ./sentence_tokenize.py "$(DST_DIR)/notag_moses.txt" "$(DST_DIR)/notag_moses_sent.txt"

word-tokenize:
	[ -f "$(DST_DIR)/notag_moses_sent_word.txt" ] || python ../../tools/multi_tok.py 'pl' < "$(DST_DIR)/notag_moses_sent.txt" > "$(DST_DIR)/notag_moses_sent_word.txt"


trim:
	ls $(DST_DIR)/* | xargs -I {} bash -c  "[ ! -s {} ] &&  rm {}" || echo -n ""

all: notag moses-normalize	sent-tokenize	word-tokenize
