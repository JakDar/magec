spm_dir=../../models/tools/marian-dev/src/3rd_party/sentencepiece/build/src
tools_dir=../tools

confusion:
	python $(tools_dir)/conf_lists_enchant.py -v ./spm/vocab.spm -d pl_PL --spm > confusion.tsv

err:
	cat ./corr.spm.txt | python $(tools_dir)/mix_words.py -c ./confusion.tsv  | \
	$(spm_dir)/spm_decode --model=spm/model.spm  | python $(tools_dir)/mix_chars.py > err.txt

split:
	mkdir split
	$(tools_dir)/split.py --output-dir ./split --corr-file ./corr.txt --err-file ./err.txt -r 0.2
