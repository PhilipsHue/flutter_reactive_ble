import SwiftProtobuf

typealias PlatformMethodCompletionHandler = (PlatformMethodResult) -> Void

enum PlatformMethodResult {
    case success(SwiftProtobuf.Message?)
    case failure(FlutterError)
}

struct AnyPlatformMethod<Context> {

    typealias Body = (Context, Any?, @escaping FlutterResult) -> Void

    let name: String
    private let body: Body

    init(_ base: NullaryPlatformMethod<Context>) {
        self.name = base.name
        self.body = { context, args, completion in base.call(in: context, arguments: args, completion: completion) }
    }

    init<Args: SwiftProtobuf.Message>(_ base: UnaryPlatformMethod<Context, Args>) {
        self.name = base.name
        self.body = { context, args, completion in base.call(in: context, arguments: args, completion: completion) }
    }

    func call(in context: Context, arguments args: Any?, completion: @escaping FlutterResult) {
        body(context, args, completion)
    }
}

struct NullaryPlatformMethod<Context> {

    typealias Body = (String, Context, @escaping PlatformMethodCompletionHandler) -> Void

    let name: String
    private let body: Body

    init(name: String, _ body: @escaping Body) {
        self.name = name
        self.body = body
    }

    func call(in context: Context, arguments args: Any?, completion: @escaping FlutterResult) {
        guard args == nil
        else {
            let result = PluginError.invalidMethodCall(method: name, details: "no arguments required").asFlutterError
            completion(result)
            return
        }

        body(name, context, { result in
            switch result {
            case .success(let message):
                let result = message
                    .map { message -> Any in
                        do {
                            return FlutterStandardTypedData(bytes: try message.serializedData())
                        } catch {
                            return PluginError.unknown(error).asFlutterError
                        }
                    }
                completion(result)
            case .failure(let error):
                completion(error)
            }
        })
    }
}

struct UnaryPlatformMethod<Context, Args: SwiftProtobuf.Message> {

    typealias Body = (String, Context, Args, @escaping PlatformMethodCompletionHandler) -> Void

    let name: String
    private let body: Body

    init(name: String, _ body: @escaping Body) {
        self.name = name
        self.body = body
    }

    func call(in context: Context, arguments args: Any?, completion: @escaping FlutterResult) {
        guard let data = (args as? FlutterStandardTypedData)?.data
        else {
            let result = PluginError.invalidMethodCall(method: name, details: "an argument of type \"\(Args.self)\" is required").asFlutterError
            completion(result)
            return
        }

        do {
            let args = try Args(serializedData: data)
            body(name, context, args, { result in
                switch result {
                case .success(let message):
                    let result = message
                        .map { message -> Any in
                            do {
                                return FlutterStandardTypedData(bytes: try message.serializedData())
                            } catch {
                                return PluginError.unknown(error).asFlutterError
                            }
                        }
                    completion(result)
                case .failure(let error):
                    completion(error)
                }
            })
        } catch {
            let result = PluginError.invalidMethodCall(method: name, details: "a (de-) serialization error occured: \"\(error)\"").asFlutterError
            completion(result)
        }
    }
}
