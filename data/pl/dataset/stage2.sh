#!/bin/sh
set -eu

train=../../../models/tools/marian-dev/src/3rd_party/sentencepiece/build/src/spm_train
$train --bos_id=0 --eos_id=1 --unk_id=5 --input=./data/stage1/dataset  --max_sentence_length=7000000 --model_prefix=dataset

mkdir -p ./data/stage2
mv ./dataset.model ./data/stage2/
mv ./dataset.vocab ./data/stage2/

python conf_lists_enchant.py -v ./data/stage2/dataset.vocab -d pl_PL --spm >  ./data/stage2/confusion.tsv
