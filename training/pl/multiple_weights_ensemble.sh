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
OUT=$SCRATCH/magecout

mkdir -p "$OUT/evaluate.many.nmt"

#../../data/pl/evaluation/wikied_v1_before
ERROR_FILE=$1
shift
GPUS="$1"
shift

model_list() {
	count=$1
	model_name=$2

	result=""
	for x in $(seq 1 $count); do
		result="$result $OUT/model${x}/$model_name"
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
d=0

for nmt_count in $(seq 1 4); do
	for i in $(seq 1 8); do #lm percentage
        echo $d run
		# TODO:bcm
		lm=0.$i
		nmt_weight=0$(echo "(10 - $i) / ($nmt_count *10)" | bc -l | head -c 5 )

		nmt_models="$(model_list "$nmt_count" model.npz.best-cross-entropy.npz)"
		nmt_weights="$(weight_list "$nmt_count" $nmt_weight)"

		OPTIONS="-m  $nmt_models $OUT/lm1/lm.npz.best-ce-mean-words.npz --weights $nmt_weights $lm -v $OUT/vocab.spm $OUT/vocab.spm --mini-batch 32 --beam-size 6 --normalize 1.0 --max-length 120 --max-length-crop --quiet-translation"

        d=$((d +1))

		cat "$ERROR_FILE" | $MARIAN/marian-decoder $OPTIONS -d $GPUS 2>$OUT/ensemble.stderr \
			>"$OUT/evaluate.many.nmt/ensemble.corrected.best_ce.${nmt_count}nmt.lmpercent$lm.out"

	done

done

echo done
