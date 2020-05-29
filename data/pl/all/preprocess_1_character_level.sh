#!/usr/bin/env bash
set -euo pipefail

mkdir -p output/stage1/wikipedia
test -d wikipedia_input || cp -r ../wikipedia/stage1/data/final_batch wikipedia_input
# cp -r ../ppc/data/final_batch wikipedia_input
# cp -r ../opensubtitles/data/final_batch wikipedia_input

# 1. Moses
# 2. Parens
# 3. Letter normalization.
# 4. Sentencize
# 5. Word tokenize
# echo "failing"
# exit 1

# mkdir -p  ppc/ppc_moses
# ls ppc/ppc_original/ | parallel --no-notice --pipe -j 6 --block 1M  ./fix_punctuatuon.sh #xargs -I {} sh -c "$moses_punctuation -l pl <ppc/ppc_original/{} >ppc/ppc_moses/{}"


moses_punctuation="../../tools/moses-scripts/scripts/tokenizer/normalize-punctuation.perl"
ls wikipedia_input | parallel -j6 "$moses_punctuation -l pl < wikipedia_input/{} |  sd '\([^\)]{1,60}\)' ' '  > output/stage1/wikipedia/{}"


# For ppc
# sd '^\w{1,2}[\.)]' ''  < ppc_rub > ppc_rub_no_prefix
