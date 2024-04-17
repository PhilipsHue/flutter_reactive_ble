#!/bin/bash -ex
export PATH="$PATH:$FLUTTER_ROOT/.pub-cache/bin"
export PATH="$PATH:$FLUTTER_ROOT/bin"

dart pub global activate melos 2.9.0

melos bootstrap
melos run analyze
melos run unittest
