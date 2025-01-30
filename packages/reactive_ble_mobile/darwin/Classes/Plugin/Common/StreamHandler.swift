final class StreamHandler<Context: AnyObject>: NSObject, FlutterStreamHandler {

    typealias OnListenHandler = (Context, EventSink) -> FlutterError?
    typealias OnCancelHandler = (Context) -> FlutterError?

    private let name: String
    private weak var context: Context?
    private let onListenBody: OnListenHandler
    private let onCancelBody: OnCancelHandler

    init(name: String, context: Context, onListen: @escaping OnListenHandler, onCancel: @escaping OnCancelHandler) {
        self.name = name
        self.context = context
        self.onListenBody = onListen
        self.onCancelBody = onCancel
        super.init()
    }

    func onListen(withArguments args: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        assert(args == nil)

        guard let context = context
        else {
            return PluginError.internalInconcictency(
                    details: "\(StreamHandler.self)(name: \"\(name)\").\(#function) is called when the context is destroyed"
                )
                .asFlutterError
        }

        return onListenBody(context, EventSink(name: name, eventSink))
    }

    func onCancel(withArguments args: Any?) -> FlutterError? {
        assert(args == nil)

        guard let context = context
        else {
            return PluginError.internalInconcictency(
                    details: "\(StreamHandler.self)(name: \"\(name)\").\(#function) is called when the context is destroyed"
                )
                .asFlutterError
        }

        return onCancelBody(context)
    }
}
