#!/bin/bash
fd text_structure.xml .. | parallel --no-notice --pipe -j 6 --block 1M ./convert.sh
#cat ./xmls.txt | parallel --no-notice --pipe -j 6 --block 1M ./convert.sh
