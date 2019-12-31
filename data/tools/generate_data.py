#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function, unicode_literals, division

# We synthesize erroneous sentences as follows:
# given a confusion set Ci = {ci1 , ci2 , ci3 , ...}, and the
# vocabulary V ,
# - we sample word wj ∈ V from the input sentence with a probability approximated wit # a normal distribution N (pWER , 0.2), and perform
# one of the following operations:
# (1) substitution of wj with a random word cjk from its confusion set with probability psub ,
# (2) deletion of wj with pdel ,
# (3) insertion of a random word wk ∈ V at j + 1 with pins ,
# (4) swapping wj and wj+1 with pswp .
#
# When making a substitution, words within confusion sets are sampled uniformly.

# To improve the model’s capability of correcting spelling errors we randomly perturb 10% of  characters using the same edit operations as above.

# Character-level noise is introduced on top of the synthetic errors generated via confusion sets.
# A MAGEC model is trained solely on the synthetically noised data and then ensembled with a
# language model. Being limited only by the amount
# of clean monolingual data, this large-scale unsupervised approach can perform better than training
# on small authentic error corpora. A large amount
# of training examples increases the chance that synthetic errors resemble real error patterns and results
# in better language modelling properties.

# If any small amount of error-annotated learner
# data is available, it can be used to fine-tune the
# pre-trained model and further boost its performance. Pre-training of decoders of GEC models from language models has been introduced by
# Junczys-Dowmunt et al. (2018b), we pretrain the
# full encoder-decoder models instead, as proposed
# by Grundkiewicz et al. (2019).
import sentencepiece
from functional import seq
import random
from typing import List, Optional, Tuple, Dict

SPM_MODEL = "/home/owner/blob/data/nlp/wikipl/plwiki/spm/ala.makota.model"
SPM_VOCAB = "/home/owner/blob/data/nlp/wikipl/plwiki/spm/ala.makota.vocab"
SOURCE_FILE = "~/blob/data/nlp/wikipl/plwiki/derv/sentences_20_sortuniq.txt"
TOKENIZED_FILE = "/home/owner/blob/data/nlp/wikipl/plwiki/derv/sentences_20_sortuniq_spm.txt"
DST_FILE = "./errors.txt"

CONFUSION_SET_FILE = "./confustion.tsv"


def load_confusion_set():
    with open(CONFUSION_SET_FILE) as f:
        return {
            s[0]: s[1:] for s in seq(f.readlines()).map(lambda line: line[:-1].split("\t"))
        }


def load_spm_vocab():
    return seq.csv(SPM_VOCAB).map(lambda row: row[0].split("\t")[0]).to_list()


roWER = 0.15
# should be normal distrib, not sure how to do it


def alter_spm(tokenized: List[str], cs: Dict[str, List[str]], vocab: List[str]) -> None:
    for i, tok in enumerate(tokenized):
        if random.random() < roWER:  # TODO:bcm
            modify_token(tokenized, i, cs, vocab)


typoER = 0.1


def alter_letter(text: str, letters: List[str]) -> None:
    t = list(text)

    for i in range(len(t)):
        if random.random() < typoER:  # TODO:bcm
            modify_letter(t, i, letters)
    return "".join(t)


PSUB = 0.7
PDEL = 0.1
PINS = 0.1
PSWP = 1 - PSUB - PDEL - PINS  # rest

P_SUB_DEL = PSUB + PDEL
P_SUB_DEL_INS = P_SUB_DEL + PINS


def modify_token(tokenized: List[str], i: str, cs: Dict[str, List[str]], vocab: List[str]):
    r = random.random()
    if r < PSUB:
        sub_token(tokenized, i, cs)
    elif r < P_SUB_DEL:
        del_token(tokenized, i)
    elif r < P_SUB_DEL_INS:
        ins_token(tokenized, i, vocab)
    else:
        swp_token(tokenized, i)


def modify_letter(tokenized: List[str], i: str, vocab: List[str]):
    r = random.random()
    if r < PSUB:
        sub_letter(tokenized, i, vocab)
    elif r < P_SUB_DEL:
        del_token(tokenized, i)
    elif r < P_SUB_DEL_INS:
        ins_token(tokenized, i, vocab)
    else:
        swp_token(tokenized, i)


def sub_token(tokenized: List[str], i: str, cs: Dict[str, List[str]]):
    idx = max(len(tokenized) - 1, i)
    key = tokenized[idx]
    if key in cs.keys():
        tokenized[idx] = random.choice(cs[key])


def sub_letter(tokenized: List[str], i: str, vocab: List[str]):
    idx = max(len(tokenized) - 1, i)
    tokenized[idx] = random.choice(vocab)


def del_token(tokenized: List[str], i: str):
    if i < len(tokenized):
        del tokenized[i]


def ins_token(tokenized: List[str], i: str, vocab: List[str]):
    tokenized.insert(i + 1, random.choice(vocab))


def swp_token(tokenized: List[str], i: str):
    if i + 1 < len(tokenized):
        tokenized[i], tokenized[i + 1] = tokenized[i + 1], tokenized[i]


def main():
    spm = sentencepiece.SentencePieceProcessor()
    spm.load(SPM_MODEL)
    spm.load_vocabulary(SPM_VOCAB, 1000)
    with open(TOKENIZED_FILE) as f:
        for line in f.readlines(1000):
            clean = spm.decode_pieces(line.split(" ")).replace("▁", " ")
            print(clean)


def decode(spm, toks: List[str]):
    return spm.decode_pieces(toks).replace("▁", " ")


if __name__ == '__main__':

    alphabet = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:<=> '  # ?;@[\\]^_`{|}~ '
    alphabet = list(alphabet)

    spm = sentencepiece.SentencePieceProcessor()
    spm.load(SPM_MODEL)
    spm.load_vocabulary(SPM_VOCAB, 1000)

    cs = load_confusion_set()
    vocab = load_spm_vocab()

    def orig_and_changed(tok: List[str]):
        print("==================")
        print(decode(spm, tok))
        alter_spm(tok, cs, vocab)

        spm_altered = decode(spm, tok)
        typo_altered = alter_letter(spm_altered, alphabet)
        print(typo_altered)

    with open(TOKENIZED_FILE) as orig_file:

        ala = orig_file.readlines()
        for line in random.sample(ala, 30):
            orig_and_changed(line.split(" "))
