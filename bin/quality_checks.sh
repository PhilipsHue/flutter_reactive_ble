#!/bin/bash -ex
#workaround for codemagic CI since melos is not in bash
echo 'export PATH="$PATH":"$FLUTTER_ROOT/.pub-cache/bin"' >>~/.bashrc 
echo 'export PATH="$PATH":"$FLUTTER_ROOT/bin"' >>~/.bashrc 
source ~/.bashrc

dart pub global activate melos

melos bootstrap
melos run analyze
melos run unittest
