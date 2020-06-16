import enchant
from functional import seq
import sys
import fire


dpl = enchant.Dict("pl_PL")
dus = enchant.Dict("en_US")
dgb = enchant.Dict("en_GB")


def in_dicts(w: str):
    return len(w) == 0 or w.isnumeric() or dpl.check(w) or dus.check(w) or dgb.check(w)


invalid_limit = 5 # maybe 4?
invalid_percent_limit = 0.6


def main(errorfile: str):
    with open(errorfile, mode="w+") as err:
        buf = []
        for line in sys.stdin:
            line_split = line.split(" ")
            invalid_cnt = seq(line_split).map(in_dicts).filter(lambda x: x is False).take(invalid_limit).size()

            if invalid_cnt < invalid_limit and  invalid_cnt / len(line_split) <  invalid_percent_limit :
                print(line)
            else:
                buf.append(line)
                if len(buf) > 100:
                    err.writelines(seq(buf).map(lambda l: l + "\n"))
                    buf.clear()

        err.writelines(seq(buf).map(lambda l: l + "\n"))


if __name__ == '__main__':
    fire.Fire(main)
