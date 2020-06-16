#!/usr/bin/env python
import enchant
from functional import seq
import sys


dpl = enchant.Dict("pl_PL")
dus = enchant.Dict("en_US")
dgb = enchant.Dict("en_GB")


def in_dicts(w: str):
    return len(w) == 0 or dpl.check(w) or dus.check(w) or dgb.check(w)


invalid_limit = 5


def main():
    for line in sys.stdin:
        sp = line.split(" ")
        spl = len(sp)
        invalid_cnt = seq(sp).map(in_dicts).filter(lambda x: x is False).take(invalid_limit).size()
        if spl > 0:
            print("{},{}".format(invalid_cnt / spl, invalid_cnt))
        else:
            print("0.0,0.0")


if __name__ == '__main__':
    main()
