#!/bin/bash -ex
export PATH="$PATH:$FLUTTER_ROOT/.pub-cache/bin"
export PATH="$PATH:$FLUTTER_ROOT/bin"

dart pub global activate melos

melos bootstrap
melos run analyze
melos run unittest
