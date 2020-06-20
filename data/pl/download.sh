#!/bin/sh
set -eu

mkdir -p split

# Dev err

for dataset in dev train; do
	for corpus in err corr; do
		curl -X GET \
			-o "split/$dataset.$corpus.txt.gz" \
			"https://storage.googleapis.com/storage/v1/b/magec-train-data/o/${dataset}_${corpus}.gz?alt=media"
	done
done
