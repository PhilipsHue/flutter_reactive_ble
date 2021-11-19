#!/bin/bash -ex
flutter pub global activate melos    
#workaround for codemagic CI since melos is not in bash
echo 'export PATH="$PATH":"$FLUTTER_ROOT/.pub-cache/bin"' >>~/.bashrc 
echo 'export PATH="$PATH":"$FLUTTER_ROOT/bin"' >>~/.bashrc 
source ~/.bashrc

melos bootstrap
melos run analyze
melos run unittest