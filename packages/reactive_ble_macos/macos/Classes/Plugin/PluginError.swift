import protocol SwiftProtobuf.Message

enum PluginError: Error {

    case unknown(Error)

    case internalInconcictency(details: String?)

    case unsupportedMethodCall(method: String)
    case invalidMethodCall(method: String, details: String?)

    case messageDeserializationFailure(type: Message.Type, underlyingError: Error)
    case messageSerializationFailure(type: Message.Type, underlyingError: Error)

    case notInitialized

    case connectionLost

    var asFlutterError: FlutterError {
        switch self {
        case .unknown(let error as NSError):
            return makeFlutterError(code: "\(error.domain):\(error.code)", message: error.localizedDescription, details: error.userInfo)
        case .internalInconcictency(let details):
            let extra = details.map { " (\($0))" } ?? ""
            return makeFlutterError(message: "internal inconsistency" + extra)
        case .unsupportedMethodCall(let method):
            return makeFlutterError(message: "the method \"\(method)\" is not supported")
        case .invalidMethodCall(let method, let details):
            let extra = details.map { " (\($0))" } ?? ""
            return makeFlutterError(message: "invalid \"\(method)\" method call" + extra)
        case .messageDeserializationFailure(let type, let underlyingError):
            return makeFlutterError(message: "failed to deserialize a message of type \(type) (\(underlyingError))")
        case .messageSerializationFailure(let type, let underlyingError):
            return makeFlutterError(message: "failed to serialize a message of type \(type) (\(underlyingError))")
        case .notInitialized:
            return makeFlutterError(message: "not initialized")
        case .connectionLost:
            return makeFlutterError(message: "connection lost")
        }
    }

    private func makeFlutterError(code: String? = nil, message: String?, details: Any? = nil) -> FlutterError {
        return FlutterError(code: code ?? "\(self)", message: message, details: details)
    }
}
