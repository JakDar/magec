#!/usr/bin/env bash
set -e

LANG=pl
WIKI_DIR=data


mkdir -p $WIKI_DIR
cd $WIKI_DIR

BASE_FILE="${LANG}wiki-latest-pages-articles.xml"
DUMP_FILE="${BASE_FILE}.bz2"
if [ ! -f $DUMP_FILE ]; then wget -c "https://dumps.wikimedia.org/${LANG}wiki/latest/${DUMP_FILE}"; fi
echo Downloaded

if [ ! -f $BASE_FILE ]; then bunzip2 $DUMP_FILE; fi
if [ ! -d wikiextractor ]; then git clone https://github.com/attardi/wikiextractor.git; fi

python wikiextractor/WikiExtractor.py --processes 4 --no_templates --min_text_length 1400 \
  --filter_disambig_pages --log_file log -b 100G -q $BASE_FILE

mv text/AA/wiki_00 $WIKI_DIR
rm -rf text
echo "Saving data in $WIKI_DIR"
