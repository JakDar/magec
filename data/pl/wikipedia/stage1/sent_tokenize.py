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


generated = {'w.w', 't.a.t.u', 'b.e.t.h', 'jap', 'm.p.z.t', 'dypl', 'tjn',
             'a.f', 'h.c', 'ćw', 'corp', 'm.s.wojsk', 'c.z.m', 't.n.t', 'a.f.c',
             't.c.b.s', 'c.c.b.i', 'dol', 'p.c.l', 'g.r', 'a.w', 'żer', 'j.m',
             'r.u.l.e', 'prod', 'i.k.c', 'dh.9', 'katol', 'x.a.n.a', 'p.v',
             'tyb', 'm.i.a', 'r.f', 'ukr', 'f.b.c', 'n.f', 'd.r.i', 'duń',
             'letell', 'd.o.k', 'n.r', 'b.i.g', 'wswoj', 'dogr', 'p.y.t',
             'biał', 'dop', 'a.p', 'komp', 'b.k', 's.p.q.r', 'nieuwl', 'm.t',
             'j.ś', 'e.j', 'r.r.x', '„mr', 'mong', 'w.in', 'uzb', 'wrsz', 'węg',
             'ogł', 'pseud', 'a120', 'l.a', 'ws', 'p.j', 'goc', 'sł', 'j.h',
             'sek', 'reż', '„c.k', 'm.c', 'kazn', '5a', 'rés', 's.d', 'e.l.s',
             's.s.a', 'k.c', 'cpt', 'i.r.s', 'yb', 'l.w.f', 'g34', 'p.s', 'dyr',
             'w.l', 's.k.a', 'с', 'w.e.b', 'w.b', 'g.m', 'μa', 'zmot', 'krm',
             'kard', 'feat', 'r.ż', 'j.k', 'l.e.o', 'c.k.m', 'p.11', 'tyt',
             'salisb', 'proj', 'j.k.m', 'v.i.p', 'y.o.”', 'fū', 'czł', 'rez',
             'comm', 'i.g', 'r.e.d', 'w.m', 'hafenstr', 'schneid', 'м', 'hiszp',
             'e.d.i', 'k.i', 'w.c', 'o.w.m', 's.t.e.f', 's.s', 'f.a', 'zpav',
             'trb', 'j1', 'kapł', 'v70', 's.r.o', 'wz', 'i.j', 'r8', '12”',
             'zał', 'y〉', 'j.w', 'g01', 'bagn', 'm.st', "'hér", 'l.t', 'a.c.f',
             'h.g', 'm.d', 'm.13', 'a.e', 'f.p', 'e.c', 'ł.s', 'p.”', 'b.r',
             't.m.c', 'św.św', 'walp', 'tc1', 'st', 'coll', 'a.a', 'o.p',
             'pdr', 'k.s', 't.p.d', 'j.u', 'złr', '«р', 'w.j', 'n.y.u', 'j.t',
             'o.w.c.a', 'geogr', 'l.b', 'engl', 'fiń', 'zala', 'r.h', 'j.o',
             's.l.m', 'q.p.g.a', 'wyd', 'złp', 'skirg', 'stgr', 'wsch', 'a.c',
             '2s', 'k.d', 'rchb', 'n.e', '11b', 'k.w', 'fru', 'b.b', 'h.w',
             'chiń', 'p.c', 'j.k.s', 'm.a', 'b.j', 'h.a', 'e.t.a', 'w.p', 'b.c',
             'km/godz', 'f.r', 'w.s', 'i.i', 'аз', "'j.r", 'c.-k', 's.a.r.l',
             'j.f.k', '6d', 'kuhlm', 'jь', 'pamot', 'r.a.s', 'f.s', 'u.i.s.p',
             '6g', 'r.u.r', 'm·s', 'э', 'j.r.r', 'g.h', 'u.m.o', 'o.i', 'h.l',
             'o.m.t', 'p.uł', 's.m', 'jęz', 'w.g', 'n.n', 'e.g', 'в.л', 'p.d.s',
             'm.p', 'i.a.l', 'b.h.n', 'wyst', 'w.e.w', 't.w', 't.s', 'krawcy',
             'ruż', 'inc', 'd.i.y', 'r.r', 'męż', 'j.d', '2019r', 'vdk', 'cyt',
             'n.a', 'ruą', 'wyk', 'w.k.l', 'đế', 'inval', 'c.w', 'c.k', 'k.p.k',
             'łuż', 'ľ', 'p.a', 'ch.w', '„trad', 'g.a', 'ok”', 'ën', 'p.a.f.f',
             'brongn', 'l.g', 'hansastr', 'jmp', 'karaim', 'r.e.m', 'o.o”',
             'obw', 'ptf', 'p.p.h.u', 'r.s.a', 'h-a', 'h.f', 'w.f', 'r.-m',
             'j.o.b', 'c.c', 'u.c.m.f', 'fabr', 'pers', 'n°', 'śl', 'ł.k.s',
             'syc', 'b.ii', 'r.k', 'irs', 'oksyt', 'a.s.a', 'e.v', 'płn',
             'k.u.k', 'g.p.o', 'ség', 'n.w', 'b.f', 'i.b.s.a', 'l.dz',
             'p.a.p', 'plut', 'tyg', 'r.j', 'w.a.b', 'poj', 's.l.s.a', 's.p',
             'śr', '·x', 'c.b.c.i', 'k.k', 'd.j', 'a.h', '01.01.2014r', 'gśl',
             'e.a', 'o.o', 's.a.l', 'adm', 'кн.2', 'pil', 'fk.8', 'nab', 'j.a',
             'd.w', 'l.poj', 'transkr', 'k.u.k', 's.r', 'płw', 's.h', 'j.b.s',
             'wlk', 'szw', 'w.n.e', 'p.t.a', 'l.f', '12t', 'k.r', 'n.p.n', 'e2',
             'płd', 'g.p', 'bł', 't.a', 'g.i', 'rajchenb', 'nyn', 'o.o.”',
             'p.o.w', 'śp', 'f.d', 't.r', 'n.v', 'meisn', 'kal', 'j.v', 'a.ł',
             's.c', 'a.g', 'h.w.s', 'dosł', 's.j', 'a.w.38', 'pdt', '8d',
             'p.p.m', 'v.m', 'd.p', '„p.p', 'a.j.p', '1.1s', 'g.b', 'jacq',
             'bø', 'w.p.n.e', 'tuły', 'ś.o.k', 't.77', 's.w', 'wzg', 'odc',
             'b.o.m.b', 'aviojet', 'grec', 'egip', 'spenn', 'psł', 'chr',
             'wifi', '>dz', '4.2bsd', 'r.i.p', 'l.mn', 'p.m', 'd.a.g', 'norw',
             'u.g.w', 'n.y', 'bułg', 's.a.r', '226/tjn', 'g.n', 'jid',
             'm.szesc', 'u.s', 'zb', 'v.j', 'a.n', 'r.n', 'i.f', 'т', 'd.m',
             'h.e.a.t', 'k.p', 'c60', 'inw', 'n.h.k', 'bkpanc', 'v.a.m.p',
             'a.d.i.d.a.s', 'w.x.l', 'tup', '„dr', 'p.a.s', 'nie”', 'k.j',
             'prał', 'a-1c', 'vz', 'isl', 'hist', 'd.f', 'o.c.t.u', 'rż', 'org',
             'c.h', 'p.a.l', 'j.s', 'tc', 'r.t', 'orygin', 'm.n', 'dpleg',
             'st44', 'prawosł', '02.04.1957r', 'gim', 'ogn', 'p.d.r.g', 'pleg',
             'r.l', 'l.s.d', '7w', 'i.d', 't.o.e', 'o.s.t.r', 'p.f', 'hook.f',
             'e.e', 'm.f', 'd.t', 'l.o', 'f.w', 'c.j', 'a.k', 'z.b.v', 'p.e',
             'p.r.c', 'g.d', 'im.s', 'św', 'j-9', 's.i', 'ucz', '2.a3',
             'm.o.p', 'k.i.d.s', 'g37', 'm.m', 'gł', 'd.c', 'u.w', 's',
             'mswojsk', 'k.a', 'a.o.l', 'o.f', 'wlkp', 's.r.l', 'turpin', 'o.g',
             'loa', '5c', '„r', 'lic', 'b.v', 'a.i.m', 'z.o.o', '5s', 'p.s.p”',
             'lindl', 'g.m.b.h', 'w.z', 'n.i', 'cz.zł', 'ulę', 'šv', 'dł', 'p.n', 'bg',
             'z.d', 'sp.k', 'j.r', 'c.a', 'ph.d', 'd.b', 'p.k.p', 'v.r', 'k.m',
             'm.b.b.s', 'j.e.b', 'j.e', '0.4s', 'gasp', 'lit.–biał', 'erchb',
             'piech', 't.h.c', 'i.d.e.a', 'jedynow', 't8', 'f.h', 'd.n', 'j.f',
             'с.с', 'j.-f', 'ś.b', 'r.br', 'trad', 'inf', 'p.w', '„f', 'urz',
             'addu', 'w.h', 'gpa', 'g.k', 'c.o.p', 'pp”', 'ww', 'p.l', 'pobed',
             'wkb', 'c.f.p', 'bohd', 'n.b', 'a.b', 'åbo', 'f.b', '„trill”',
             'p.ch', 's.k.f', 'ä.l', 'b22', 'l.a.d', 'k.a.w', 'r.a.a', 's.l',
             'w.d.j', 'czetw', 'brna', 'j.i', 'lehm', 'go”', 'r.g', '1.6s',
             'e.s', 'folw', '.o.o', 'backeb', 'u.u.w', 'wiet', 'h.s', 'g64',
             'dka', 'aubl', 'orth', 'h.p', 't.k.o', 'nacz', 'a.fd', 'cz.1',
             'mołd', 'erb', 'zd', 'wąsk', 'oo', 'takht', 'dopł', 'z.mo',
             'nacz./nacz', 'temp', 'l.v', 's.w.a.t', 'a35', 'b.g', 'a.s', 'p.o',
             'i.v', 'e.l', 'zabrza', 'gr.1', 'rozkoln', 'woł', 'słow', 'dyw',
             'c.s', 'f+', 's.o.s', 'śś', 'rtm', 'h.h', 'l.d', 'mtv2', 'b.e',
             'zwł', '8a', 'g.k.s', 'wydz', 'd.k', 'a.j', 'dep', 's.54', 'g.g',
             'a.i', 'k.a.w.a', 'ro', 's.g.c', 'dstrz', 'b.a', 'b.y.o.b', 'miq',
             'n.m.p', 'prawosław', 'r.n.e', '5p', 'junior-k.r.y', 'ab2',
             's.n.y', 'atri', 'q.e.d', 'juss', 't.zw', 'w.a', 'wylie', 'subsp',
             'n.p', 's.i.r', 'j.c', 'r.y.s', 'l.w', 'kaw', 'l.k', 'ludwigstr',
             'e.-j', 'odb', 'ssp', 'dz.u', 'oryg', 'a.d', 'p.t',
             'j.j', 'g.w', 'p.n.e', 't.j.a', 'd.z', 'g12', 's.l.e.r', 'arn',
             'a.r', 'd.f.-g', 'n.s', 'g.f', 'x.a.n.y', 'mł', 'wadm', 'a.m',
             '12,000rs', 'dlek', 'ind', 'u.s.f', 'f.e', 'ochot', 'szk', 'o.j',
             't.23', 'g.t', 'adw', 'propin', 'l.p', 'i.in', 'j.p', 'rydb',
             'u.s', 'h.j', 'strz', 'sgt', 'n.y', 't.d', 'dzies', 'p.i', 'półn',
             'krypt', 'i.k', 'wym', 'jez', 'w.i', 'a.-g', 'k.u', 'l.o.p.p',
             'o.c', 'w.r', 'z”', 'j.b', 'oio', 'pappanc'}



punkt_param = PunktParameters()
punkt_param.abbrev_types = ADDITIONALS.union(generated)

tokenizer = PunktSentenceTokenizer(punkt_param)


def tokenize(from_file: str, to_file: str) -> None:
    lines: List[str] = seq(tokenizer.tokenize(open(from_file).read())).map(
        lambda x: x.replace("\n"," ") + "\n"
    ).to_list()
    open(to_file, "w").writelines(lines)


if __name__ == "__main__":
    tokenize(sys.argv[1], sys.argv[2])
