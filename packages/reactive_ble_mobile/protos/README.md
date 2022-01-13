# Protobuf code generation

1. Install the newest `protoc`. It can be done via `brew`: 

```sh
brew install protobuf
```

2. For Swift code generation install :

```sh
brew install swift-protobuf
```

3. If you don't have Dart SDK on your computer please install it.

```sh
brew install dart
```

4. Run `pub global activate protoc_plugin`
5. OPTIONAL Add plugin path to `PATH` environment variable
6. Run the following command from the "protos" directory

```sh
protoc --dart_out=../lib/src/generated ./bledata.proto
protoc --swift_out=../ios/Classes/BleData ./bledata.proto
```

NOTE: If directory `../lib/generated` or `./ios/Classes/BleData` does not exist please create it.
