spm_dir=../../models/tools/marian-dev/src/3rd_party/sentencepiece/build/src
tools_dir=../tools
https://drive.google.com/file/d/1NaIs7WkB6jCqKhky6F5jXb1sfhRCuPRs/view?usp=sharing
orig_cor=../tools/gen_sentences/files/notag_moses_sent_word_len_rub_dict_chr_num.txt
corr_file=./corr.txt
corr_spm_file=./corr.spm.txt
err_file=./err.txt

corr:
	cp $(orig_cor) $(corr_file)

spm: corr
	mkdir -p spm
	$(spm_dir)/spm_train --bos_id=0 --eos_id=1 --unk_id=5 --input=$(corr_file) --max_sentence_length=7000000 --model_prefix wikipl
	mv wikipl.* spm/

encode: spm corr
	$(spm_dir)/spm_encode   --model=./spm/wikipl.model <  $(corr_file)  > $(corr_spm_file)

confusion:
	python $(tools_dir)/conf_lists_enchant.py -v ./spm/wikipl.vocab -d pl_PL --spm > confusion.tsv

err:
	cat ./corr.spm.txt | python $(tools_dir)/mix_words.py -c ./confusion.tsv  | \
	$(spm_dir)/spm_decode --model=spm/wikipl.model | python $(tools_dir)/mix_chars.py > err.txt

split:
	mkdir split
	python $(tools_dir)/split.py --output-dir ./split --corr-file ./corr.txt --err-file ./err.txt -r 0.05

compress:
	gzip split/*

all: corr spm encode confusion err split

#download:
	 # wget https://drive.google.com/uc?export=download&confirm=szJo&id=1TMir_LJcX7teFKcUDrT0q3aLr3r4oAqX
   # unzip data.zip
