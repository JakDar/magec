#!/bin/bash -v

set -euo pipefail


DATA=/content/magec/data/pl/split #//spm/
SPM_DATA=../../data/pl/spm
MODELDIR='.'
OUT=/out
MARIAN=../../models/tools/marian-dev/build

RAM=8000
GPUS=1


# mkdir -p $MODEL/eval
# cp $0 $MODEL/script.sh

$MARIAN/marian --type lm-transformer \
    -d $GPUS \
    --model "$OUT"/lm.npz \
    --train-sets "$DATA"/train.corr.txt.gz \
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
    --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
    --overwrite --keep-best \
    --log "$OUT"/train.log --valid-log "$OUT"/valid.log
