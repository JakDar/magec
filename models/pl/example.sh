#!/bin/bash -v
CONFIG=/out/model.npz.best-cross-entropy.npz.decoder.yml
echo "W 1410 roku miała miejsce bita pod gunwaldem." |
	./tools/marian-dev/build/marian-decoder -c $CONFIG $@

# echo "Мни стрелять хне из автоматов , из тяжелого оружия ." \
    # | ../marian-dev/build/marian-decoder -c config.yml $@
