#Proto files generation:
1. Install newest protoc. It can be done via brew 
``` brew install protobuf```
2. For swift install :
``` brew install swift-protobuf```
3. If you don't have dart sdk on your computer please install it.
```brew isntall dart```
4. Get the latest dart-protoc-plugin from https://github.com/dart-lang/dart-protoc-plugin
5. Go to dart-protoc-plugin-<<version>> folder and call
```pub install```
6. Add plugin path to PATH
7. Make sure protoc + protoc-gen-dart + dart bins are all in the same path
8. Run the following command from the protos folder
```
protoc --dart_out=../lib/generated ./bledata.proto
protoc --swift_out=../ios/Classes/BleData ./bledata.proto
```

   * if folder `../lib/generated` or `./ios/Classes/BleData` does not exist please create it.