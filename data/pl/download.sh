#!/bin/sh
set -eu

mkdir -p split

bucket=magec-train-data

for dataset in dev train; do
	for corpus in err corr; do
		file=${dataset}_${corpus}.gz

		curl -X GET \
			-o "split/$dataset.$corpus.txt.gz" \
			"https://storage.googleapis.com/storage/v1/b/$bucket/o/$file?alt=media"
	done
done
