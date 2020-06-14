#!/usr/bin/env python

from pprint import pprint
from nltk.tokenize.punkt import PunktSentenceTokenizer, PunktTrainer, PunktParameters
from functional import seq
from typing import List, Set
import sys


additional = """itp itd etc im rp ul pow st p ust tzn kpt n zob jr sp art o tow płk zł in
tys sygn zw nie łac późn l mn ppor r godz zm pol fr sa właśc pl ps woj b ang w
hab hebr ur pocz br gr pw nim pn min por ks mjr t al ds prof proc s poł np bryg
rok c niem czes św m hr s c pkt m ok f ppłk n inż ub m tzw pt dr ros dz tj n
uniw cm gen d m.in rel ośw pułk społ wyzn p poz nr wojsk woj roz
sz kg wzgl alin n.z.r str m² op roln fen hand kw kub xi lit spr szt r.p hekt
wys klg of bz okr pet gm pp mt wł kap kor j p.p.s zn detal podp del hk k
przem kwadr ctn it.p król h mtr wag kr kod pr rh pos przetrwały kop p.p rob kl
p.s.l ff m.l nl dba t.j jen ś zewn publ rb hal kol z.r ew roi up km ewent
rozk g wewn gub mk cyw nb dk dn"""

ADDITIONALS: Set[str] = seq(additional.replace("\n", " ").split(" ")).filter_not(
    lambda x: len(x) == 0
).distinct().to_set()


# filenames: List[str] = [x[:-1] for x in open("./data/out_index").readlines()[:20]]


# text = (
#     seq(filenames)
#     .flat_map(lambda f: open(f"data/out/{f}").readlines())
#     .map(lambda x: x[:-1])
#     .reduce(lambda x, y: x + "\n" + y)
# )


# trainer = PunktTrainer()
# trainer.INCLUDE_ALL_COLLOCS = True
# trainer.train(text)
# # print(trainer.get_params().abbrev_types.difference(additionals))

punkt_param = PunktParameters()
punkt_param.abbrev_types = ADDITIONALS

tokenizer = PunktSentenceTokenizer(punkt_param)


def tokenize(from_file: str, to_file: str) -> None:
    lines: List[str] = seq(tokenizer.tokenize(open(from_file).read())).map(
        lambda x: x.replace("\n"," ") + "\n"
    ).to_list()
    open(to_file, "w").writelines(lines)


if __name__ == "__main__":
    tokenize(sys.argv[1], sys.argv[2])
