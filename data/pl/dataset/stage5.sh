#!/bin/sh
set -eu

stage4=./data/stage4
vocab=$stage4/vocab.spm
corr=$stage4/train_corr
err=$stage4/train_err

stage5=./data/stage5
mkdir -p $stage5

encoded_corr=$stage5/encoded_train_corr
encoded_err=$stage5/encoded_train_err
weights=$stage5/weights.w2

# spm_encode=../../../models/tools/marian-dev/build/spm_encode
# $spm_encode --model=$vocab <$corr >$encoded_corr
# $spm_encode --model=$vocab <$err >$encoded_err

echo "Computing weights:"
paste $encoded_err $encoded_corr | python ./edit_weights.py -w 2 > $weights
echo "Finished, now zipping weights"
gzip -k $weights
