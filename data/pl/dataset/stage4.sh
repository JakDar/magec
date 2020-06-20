#!/bin/sh
set -eu

corr=./data/stage1/dataset
err=./data/stage3/err

stage4_dir=./data/stage4

mkdir -p $stage4_dir

if [ -f "$stage4_dir/err_corr" ]; then

	echo "Used cached corr_err file:"
	ls -lah "$stage4_dir/err_corr"
else

	corr_size=$(wc -l <$corr)
	err_size=$(wc -l <$err)

	if [ "$corr_size" -ne "$err_size" ]; then
		echo "Dataset sizes don't match"
		exit 1
	fi

	if rg '\t' -q <$corr || rg '\t' -q <$err; then
		echo "Tabulator in dataset: ABORT"
		exit 1
	fi

	paste $err $corr | shuf >$stage4_dir/err_corr
	echo "Pasted corr and err into single file"
fi

head -n 300000 <$stage4_dir/err_corr >$stage4_dir/dev_err_corr
echo "Created dev pasted dataset"

tail -n +300001 <$stage4_dir/err_corr >$stage4_dir/train_err_corr
echo "Created train pasted dataset"

for dataset in dev train; do
	awk -F'\t' '{print $1}' $stage4_dir/${dataset}_err_corr >$stage4_dir/${dataset}_err
	awk -F'\t' '{print $2}' $stage4_dir/${dataset}_err_corr >$stage4_dir/${dataset}_corr

	echo "Created $dataset dataset"
	gzip -k $stage4_dir/${dataset}_err
	gzip -k $stage4_dir/${dataset}_corr
	echo "Zipped $dataset dataset"
done

