#!/bin/bash -v

set -e
MARIAN=../../models/tools/marian-dev/build
DATA=../../data/pl/split
SPM_DATA=../../data/pl/spm
MODELDIR='.'
OUT=/out

# Before vocab
# --data-weighting "$DATA"/mono.enchant.spell.tok.w2.gz --data-weighting-type word \
#after macx length

# --vocabs "$DATA"/vocab.{spm,spm} --tied-embeddings-all \
"$MARIAN"/marian --type transformer \
	--model "$OUT"/model.npz \
	-w 7000 \
	--train-sets "$DATA"/train.err.txt.gz "$DATA"/train.cor.txt.gz --shuffle-in-ram --tempdir tmp \
	--max-length 150 \
	--vocabs "$OUT"/vocab.{spm,spm} --tied-embeddings-all \
	--enc-depth 6 --dec-depth 6 --transformer-heads 8 \
	--dropout-src 0.2 --dropout-trg 0.1 --transformer-dropout 0.3 --transformer-dropout-ffn 0.1 --transformer-dropout-attention 0.1 \
	--exponential-smoothing --label-smoothing 0.1 \
	--mini-batch-fit --mini-batch 1000 --maxi-batch 1000 --sync-sgd --optimizer-delay 4 \
	--learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
	--optimizer-params 0.9 0.98 1e-09 --clip-norm 0 \
	--cost-type cross-entropy \
	--valid-metrics cross-entropy translation perplexity \
	--valid-sets "$DATA"/dev.err.txt.gz "$DATA"/dev.cor.txt.gz \
	--valid-translation-output "$OUT"/devset.out --quiet-translation \
	--valid-script-path "$MODELDIR"/validate.sh \
	--valid-mini-batch 16 --beam-size 12 --normalize 1.0 \
	--early-stopping 5 --after-epochs 5 \
	--valid-freq 5000 --save-freq 5000 --disp-freq 500 --disp-first 5 \
	--overwrite --keep-best \
	--log "$OUT"/train.log --valid-log "$OUT"/valid.log
