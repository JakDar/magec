#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import random
import argparse
from os.path import expanduser
import tqdm


def parse_user_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--output-dir', required=True, help="Output directory", default=".")
    parser.add_argument('-c', '--corr-file', required=True, help="Correct file")
    parser.add_argument('-e', '--err-file', required=True, help="Error file")
    parser.add_argument('-r', '--split-ratio', required=True, type=float, default=0.2)
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_user_args()

    CORR_FILE = expanduser(args.corr_file)
    ERR_FILE = expanduser(args.err_file)
    SPLIT_DIR = expanduser(args.output_dir)

    with open(CORR_FILE) as corr_file, \
            open(ERR_FILE) as err_file, \
            open(SPLIT_DIR + "train.cor.txt", mode='w+') as train_corr_file, \
            open(SPLIT_DIR + "train.err.txt", mode='w+') as train_err_file, \
            open(SPLIT_DIR + "dev.cor.txt", mode='w+') as dev_corr_file, \
            open(SPLIT_DIR + "dev.err.txt", mode='w+') as dev_err_file:

        for corr, err in tqdm.tqdm(zip(corr_file.readlines(), err_file.readlines())):
            if random.random() < args.split_ratio:
                dev_corr_file.write(corr)
                dev_err_file.write(err)
            else:
                train_corr_file.write(corr)
                train_err_file.write(err)
