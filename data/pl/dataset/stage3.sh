#!/bin/sh
set -eu

mkdir -p data/stage3
python mix_words.py -c ./data/stage2/confusion.tsv <./data/stage1/dataset |
	python mix_chars.py >./data/stage3/err
