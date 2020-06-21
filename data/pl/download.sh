#!/bin/sh
set -eu

mkdir -p split

bucket=magec-train-data

for dataset in dev train; do
	for corpus in err corr; do
		file=${dataset}_${corpus}.gz

		[ -f "split/$dataset.$corpus.txt.gz" ] || curl -X GET \
			-o "split/$dataset.$corpus.txt.gz" \
			"https://storage.googleapis.com/storage/v1/b/$bucket/o/$file?alt=media"
	done
done

[ -f "split/weights.w2.gz" ] || curl -X GET \
	-o "split/weights.w2.gz" \
	"https://storage.googleapis.com/storage/v1/b/$bucket/o/weights.w2.gz?alt=media"
