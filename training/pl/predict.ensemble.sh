#!/usr/bin/env bash
set -euo pipefail

MARIAN=../../models/tools/marian-dev/build
# OUT=/out
# OUT=$SCRATCH/magecout
MODEL_DIR="$HOME/blob/data/magec_lite"

#../../data/pl/evaluation/wikied_v1_before
ERROR_FILE=$1
shift

model_list() {
	count=$1
	model_name=$2

	result=""
	for x in $(seq 1 $count); do
		result="$result $MODEL_DIR/model${x}/$model_name"
	done
	echo "$result"
}

weight_list() {
	count=$1
	weight=$2
	result=""
	for x in $(seq 1 $count); do
		result="$result $weight"
	done
	echo "$result"
}

nmt_count=4
nmt_models="$(model_list "$nmt_count" model.npz.best-cross-entropy.npz)"
i=3
lm=0.$i
nmt_weight=0$(echo "(10 - $i) / ($nmt_count *10)" | bc -l | head -c 5)

nmt_weights="$(weight_list "$nmt_count" $nmt_weight)"

OPTIONS="-m  $nmt_models $MODEL_DIR/lm1/lm.npz.best-ce-mean-words.npz --weights $nmt_weights $lm -v $MODEL_DIR/vocab.spm $MODEL_DIR/vocab.spm --mini-batch 32 --beam-size 6 --normalize 1.0 --max-length 120 --max-length-crop --quiet-translation"

cat "$ERROR_FILE" | $MARIAN/marian-decoder $OPTIONS 2>$ERROR_FILE.ensemble.stderr \
	>"$ERROR_FILE.corrected"
