#!/usr/bin/env python

from pprint import pprint
from nltk.tokenize.punkt import PunktSentenceTokenizer, PunktTrainer, PunktParameters
from functional import seq
from typing import List,Set


filenames: List[str] = [x[:-1] for x in open("./data/out_index").readlines()[:20]]


text = (
    seq(filenames)
    .flat_map(lambda f: open(f"data/out/{f}").readlines())
    .map(lambda x: x[:-1])
    .reduce(lambda x, y: x + "\n" + y)
)

trainer = PunktTrainer()
trainer.INCLUDE_ALL_COLLOCS = True
trainer.train(text)

additional = """itp itd etc im rp ul pow st p ust tzn kpt n zob jr sp art o tow płk zł in
tys sygn zw nie łac późn l mn ppor r godz zm pol fr sa właśc pl ps woj b ang w
hab hebr ur pocz br gr pw nim pn min por ks mjr t al ds prof proc s poł np bryg
rok c niem czes św m hr s c pkt m ok f ppłk n inż ub m tzw pt dr ros dz tj n
uniw cm gen d m.in rel ośw pułk społ wyzn p poz nr wojsk woj roz"""

additionals: Set[str] = seq(additional.replace("\n", " ").split(" ")).filter_not(
    lambda x: len(x) == 0
).distinct().to_set()


punkt_param = PunktParameters()
punkt_param.abbrev_types = additionals.union(trainer.get_params().abbrev_types)

tokenizer = PunktSentenceTokenizer(punkt_param)

# Test the tokenizer on a piece of text
sentences = open("./data/out/" + filenames[0]).read()


TOKENIZED = "\n\n".join(tokenizer.tokenize(sentences))

print(TOKENIZED)
# ['Mr. James told me Dr.', 'Brown is not available today.', 'I will try tomorrow.']

# # View the learned abbreviations
# print(tokenizer._params.abbrev_types)
# # set([...])

# # Here's how to debug every split decision
# for decision in tokenizer.debug_decisions(sentences):
#     pprint(decision)
#     print("=" * 30)
