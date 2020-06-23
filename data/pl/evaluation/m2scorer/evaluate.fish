#!/usr/bin/env fish


set dataset $1
set result $dataset/result
rm $result

for i in (seq 4 9 | tac)
    echo marain: 0.$i >> $result
    ./m2scorer  ./in/$dataset/ensemble.corrected_0.$i.out ./out/$dataset/gold >> $result
end
