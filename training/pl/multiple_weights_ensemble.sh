#!/usr/bin/env bash
set -euo pipefail

# if [ $# -lt 2 ]; then
# 	print "usage: $0 <dir> <gpus> <models>"
# 	exit 1
# fi

# DATA=/content/magec/data/pl/split
# DATA=$SCRATCH/magec/data/pl/split # Prometheus
# MARIAN=$TOOLS/marian-dev/build
# DATA=$ROOT/data
MARIAN=../../models/tools/marian-dev/build
# OUT=/out
OUT=$SCRATCH/magecout/

mkdir -p "$OUT/evaluate1nmt"

#../../data/pl/evaluation/wikied_v1_before
ERROR_FILE=$1
shift
GPUS=$1
shift

for i in $(seq 1 9); do
    magec=0.$i
    lm=0.$((10 - i))
    OPTIONS="-m $OUT/model1/model.npz.best-cross-entropy.npz $OUT/lm1/lm.npz.best-ce-mean-words.npz --weights $magec $lm -v $OUT/vocab.spm $OUT/vocab.spm --mini-batch 32 --beam-size 6 --normalize 1.0 --max-length 120 --max-length-crop --quiet-translation"

	cat "$ERROR_FILE" | $MARIAN/marian-decoder $OPTIONS -d $GPUS 2>$OUT/ensemble.stderr \
		>$OUT/evaluate1nmt/ensemble.corrected_0.$i.out

done
