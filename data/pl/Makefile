spm_dir=../../models/tools/marian-dev/src/3rd_party/sentencepiece/build/src
tools_dir=../tools

confusion:
	python $(tools_dir)/conf_lists_enchant.py -v ./spm/vocab.spm -d pl_PL --spm > confusion.tsv

err:
	cat ./corr.spm.txt | python $(tools_dir)/mix_words.py -c ./confusion.tsv  | \
	$(spm_dir)/spm_decode --model=spm/model.spm  | python $(tools_dir)/mix_chars.py > err.txt

split:
	mkdir split
	python $(tools_dir)/split.py --output-dir ./split --corr-file ./corr.txt --err-file ./err.txt -r 0.2

compress:
	gzip split/*

#download:
	 # wget https://drive.google.com/uc?export=download&confirm=szJo&id=1TMir_LJcX7teFKcUDrT0q3aLr3r4oAqX
   # unzip data.zip
