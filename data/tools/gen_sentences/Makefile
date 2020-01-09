SRC_FILE=/home/owner/blob/data/nlp/wikipl/plwiki/plwiki
DST_DIR=./files


notag:
	mkdir -p $(DST_DIR)
	sd  '<doc id=.{2,100}?>' 'newdocument' < $(SRC_FILE) | sd '<.{2,100}?>' '' | rg -v '^\s*$$' > $(DST_DIR)/notag.txt

moses-normalize:
	[ -f $(DST_DIR)/notag_moses.txt ] || ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl  -l pl < $(DST_DIR)/notag.txt  > $(DST_DIR)/notag_moses.txt

sent-tokenize:
	[ -f "$(DST_DIR)/notag_moses_sent.txt" ] || python ./sentence_tokenize.py "$(DST_DIR)/notag_moses.txt" "$(DST_DIR)/notag_moses_sent.txt"
	sort -u < "$(DST_DIR)/notag_moses_sent.txt" > "$(DST_DIR)/notag_moses_sent2.txt"
	mv  "$(DST_DIR)/notag_moses_sent2.txt" "$(DST_DIR)/notag_moses_sent.txt"

word-tokenize:
	[ -f "$(DST_DIR)/notag_moses_sent_word.txt" ] || python ../../tools/multi_tok.py 'pl' < "$(DST_DIR)/notag_moses_sent.txt" > "$(DST_DIR)/notag_moses_sent_word.txt"
	sort -u < "$(DST_DIR)/notag_moses_sent_word.txt" > "$(DST_DIR)/notag_moses_sent_word2.txt"
	mv  "$(DST_DIR)/notag_moses_sent_word2.txt" "$(DST_DIR)/notag_moses_sent_word.txt"

trim-by-length:
	awk '{if (length < 3000 && length >40) {print}}' < "$(DST_DIR)/notag_moses_sent_word.txt" > "$(DST_DIR)/notag_moses_sent_word_len.txt"

trim-by-length-inv:
	awk '{if (length >= 3000 || length <= 40 ) {print}}' < "$(DST_DIR)/notag_moses_sent_word.txt" > "$(DST_DIR)/notag_moses_sent_word_len_inv.txt"

remove-rubbish:
	awk -f ./take_most_alpha.awk < "$(DST_DIR)/notag_moses_sent_word_len.txt" > "$(DST_DIR)/notag_moses_sent_word_len_rub.txt"


corr_dicted:
	python ./enchant_filter.py < "$(DST_DIR)/notag_moses_sent_word_len_rub.txt" --errorfile ./corr_dict_invalid.txt > "$(DST_DIR)/notag_moses_sent_word_len_rub_dict.txt"


char_removed:
	sd '[^a-zA-Z0-9 \.,\?!żółćśźąęń\n]' '' <  "$(DST_DIR)/notag_moses_sent_word_len_rub_dict.txt" | rg -v '^\s*$$' > "$(DST_DIR)/notag_moses_sent_word_len_rub_dict_chr.txt"

num_to_one:
	sd '[0-9]' '1' <  "$(DST_DIR)/notag_moses_sent_word_len_rub_dict_chr.txt" | sd '[ ]+' ' ' | sed 's/^ //' > "$(DST_DIR)/notag_moses_sent_word_len_rub_dict_chr_num.txt"

#TODO - reorganise
trim-by-len-again:
	awk '{if (length >= 3000 || length <= 40 ) {print}}' < "$(DST_DIR)/notag_moses_sent_word.txt" > "$(DST_DIR)/notag_moses_sent_word_len_inv.txt"

# trim:
# 	ls $(DST_DIR)/* | xargs -I {} bash -c  "[ ! -s {} ] &&  rm {}" || echo -n ""

# all: notag moses-normalize	sent-tokenize	word-tokenize
