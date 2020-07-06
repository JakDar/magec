#!/usr/bin/env fish

set dataset $argv[1]
set result out/$dataset/result
mkdir -p "out/$dataset"
rm -f $result

for file in (ls ./in/$dataset/* | grep '[5-9].out' )
    echo "$file"

    echo $file >> $result
    timeout 30s sh -c "./m2scorer $file ./out/gold_v2 >> $result"
end
