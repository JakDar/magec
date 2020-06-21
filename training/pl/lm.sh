#!/bin/bash -v

set -euo pipefail

# DATA=/content/magec/data/pl/split #//spm/
DATA=$SCRATCH/magec/data/pl/split # Prometheus
MODELDIR='.'
# OUT=/out
OUT=/$SCRATCH/magecout/lm1
MARIAN=../../models/tools/marian-dev/build

if [ $# -eq 1 ]; then
	RAM=$1
	FREQ=5000
elif [ $# -eq 2 ]; then
	RAM=$1
	FREQ=$2
else
	RAM=8000
	FREQ=5000
fi

$MARIAN/marian --type lm-transformer \
	--model "$OUT"/lm.npz \
	-d 0 1 2 3 4 5 6 7\
	--train-sets "$DATA"/train.corr.txt.gz --shuffle-in-ram \
	--vocabs "$OUT"/vocab.spm --tied-embeddings-all \
	--max-length 120 --max-length-crop \
	--enc-depth 6 --dec-depth 6 --transformer-heads 8 \
	--transformer-dropout 0.1 \
	--exponential-smoothing --label-smoothing 0.1 \
	--mini-batch-fit -w "$RAM" --mini-batch 1000 --maxi-batch 1000 --sync-sgd \
	--learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
	--optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
	--cost-type perplexity \
	--valid-metrics perplexity ce-mean-words \
	--valid-sets "$DATA"/dev.corr.txt.gz \
	--valid-mini-batch 16 \
	--early-stopping 5 --after-epochs 2 \
	--valid-freq $FREQ --save-freq $FREQ --disp-freq 1000 \
	--overwrite --keep-best \
	--log "$OUT"/train.log --valid-log "$OUT"/valid.log
