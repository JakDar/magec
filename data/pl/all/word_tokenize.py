#!/usr/bin/env python

from nltk import word_tokenize


if __name__ == "__main__":
    import sys

    for line in sys.stdin:
        print(" ".join(word_tokenize(line)))
