#!/usr/bin/env fish
function preprocess
    ../../../tools/moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l pl <$argv[1] |
    sed -E 's/[^[:alnum:] ,\.\?\!]/ /Ig; s/ +/ /g' | # alphaa will alow for czech, arabic and so on
    rg -v '^\s*$' |
    sd '[0-9]' '1' | python ../../all/word_tokenize.py >$argv[2] # replace all numbers to ones, keeping length
end

test -f out/before_v1 || preprocess ../wikied_v1_before out/before_v1
test -f out/after_v1 || preprocess ../wikied_v1_after out/after_v1

scripts/edit_creator.py out/before_v1 out/after_v1 >out/gold_v1
