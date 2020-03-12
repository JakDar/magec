from fire import Fire
from functional import seq

import tqdm
from spacy.lang.pl import Polish
nlp = Polish()
nlp.max_length = 6 * 1000 * 1000 * 1000
sentencizer = nlp.create_pipe("sentencizer")
nlp.add_pipe(sentencizer)


def _sent_tokenize(data: str):
    return (sen.__repr__() for sen in nlp(data).sents)


def sent_tokenzie(in_file: str, out_file: str):
    f = open(in_file).read()

    res = open(out_file, mode='w')

    for art in tqdm.tqdm(f.split("newdocument")):
        seq(_sent_tokenize(art))\
            .grouped(500)\
            .for_each(lambda lines: res.writelines(seq(lines).map(lambda x: x + "\n")))


if __name__ == '__main__':
    Fire(sent_tokenzie)
