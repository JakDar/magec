#!/bin/bash -v

if [ $# -lt 3 ]; then
    print "usage: $0 <dir> <gpus> <models>"
    exit 1
fi

# ROOT=.
# TOOLS=$ROOT/tools
# SCRIPTS=$ROOT/scripts
DATA=/content/magec/data/pl/split #//spm/
# MARIAN=$TOOLS/marian-dev/build
# DATA=$ROOT/data
MARIAN=../../models/tools/marian-dev/build
OUT=/out

ERROR_FILE=$1
shift
GPUS=$1
shift

OPTIONS="-m $@ -v /out/vocab.spm /out/vocab.spm --mini-batch 32 --beam-size 6 --normalize 1.0 --max-length 120 --max-length-crop --quiet-translation"

# bash ./evaluate.sh models/ensemble.lm/eval "$GPUS" models/transformer.?/model.npz.best-translation.npz models/lm.2/model.npz.best-perplexity.npz \
#     --weights 1. 1. 1. 1. .4


cat $ERROR_FILE\
    | $MARIAN/marian-decoder $OPTIONS -d $GPUS 2> $OUT/ensemble.stderr \
    > $OUT/ensemble.corrected.out
    # | bash $SCRIPTS/postprocess_safe.sh \

# timeout 3m $TOOLS/m2scorer_fork $DIR/test2013.out $DATA/conll/test2013.m2 \
#     > $DIR/test2013.eval


echo "Models: $@"
# tail $DIR/*.eval
