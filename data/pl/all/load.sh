#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/in/{sub,wiki,ppc}

cp ../ppc/data/stage4/* data/in/ppc
cp ../wikipedia/stage1/data/stage4/* data/in/wiki
cp ../opensubtitles/data/stage2/* data/in/sub
