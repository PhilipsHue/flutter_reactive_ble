import enum SwiftProtobuf.BinaryEncodingError

struct EventSink {

    private let name: String
    private let sink: FlutterEventSink

    init(name: String, _ sink: @escaping FlutterEventSink) {
        self.name = name
        self.sink = sink
    }

    func add(_ event: PlatformMethodResult) {
        switch event {
        case .success(let message):
            if let message = message {
                do {
                    sink(FlutterStandardTypedData(bytes: try message.serializedData()))
                } catch let error as BinaryEncodingError {
                    sink(PluginError.messageSerializationFailure(type: type(of: message), underlyingError: error).asFlutterError)
                } catch {
                    sink(PluginError.unknown(error).asFlutterError)
                }
            } else {
                sink(nil)
            }
        case .failure(let error):
            sink(error)
        }
    }
}

