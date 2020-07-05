#!/usr/bin/env fish

set dataset $argv[1]
set result out/$dataset/result
mkdir -p "out/$dataset"
rm -f $result

for i in (seq 4 9 | tac)
    echo marain: 0.$i >> $result
    ./m2scorer ./in/$dataset/ensemble.corrected_0.$i.out ./out/gold_v1 >> $result
end
