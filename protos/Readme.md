#Proto files generation:
1. Install newest protoc. It can be done via brew 
``` brew install protobuf```
2. For swift install :
``` brew install swift-protobuf```
3. If you don't have dart sdk on your computer please install it.
```brew isntall dart```
4. Run ```pub global activate protoc_plugin```
5. OPTIONAL Add plugin path to PATH
6. Make sure protoc + protoc-gen-dart + dart bins are all in the same path
7. Run the following command from the protos folder
```
protoc --dart_out=../lib/src/generated ./bledata.proto
protoc --swift_out=../ios/Classes/BleData ./bledata.proto
```

   * if folder `../lib/generated` or `./ios/Classes/BleData` does not exist please create it.