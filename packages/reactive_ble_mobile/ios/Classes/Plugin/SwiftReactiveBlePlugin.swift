import Flutter
import enum SwiftProtobuf.BinaryEncodingError
import CoreBluetooth

public class SwiftReactiveBlePlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = SwiftReactiveBlePlugin()
        let methodChannel = FlutterMethodChannel(name: "flutter_reactive_ble_method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(plugin, channel: methodChannel)
        FlutterEventChannel(name: "flutter_reactive_ble_status", binaryMessenger: registrar.messenger())
            .setStreamHandler(plugin.statusStreamHandler)
        FlutterEventChannel(name: "flutter_reactive_ble_scan", binaryMessenger: registrar.messenger())
            .setStreamHandler(plugin.scanStreamHandler)
        FlutterEventChannel(name: "flutter_reactive_ble_connected_device", binaryMessenger: registrar.messenger())
            .setStreamHandler(plugin.connectedDeviceStreamHandler)
        FlutterEventChannel(name: "flutter_reactive_ble_char_update", binaryMessenger: registrar.messenger())
            .setStreamHandler(plugin.characteristicValueUpdateStreamHandler)
    }

    var statusStreamHandler: StreamHandler<PluginController> {
        return StreamHandler(
            name: "status stream handler",
            context: context,
            onListen: { context, sink in
                context.stateSink = sink
                return nil
            },
            onCancel: {context in
                context.stateSink = nil
                return nil
            }
        )
    }

    var scanStreamHandler: StreamHandler<PluginController> {
        return StreamHandler(
            name: "scan stream handler",
            context: context,
            onListen: { context, sink in
                return context.startScanning(sink: sink)
            },
            onCancel: { context in
                return context.stopScanning()
            }
        )
    }

    var connectedDeviceStreamHandler: StreamHandler<PluginController> {
        return StreamHandler(
            name: "connected device stream handler",
            context: context,
            onListen: { context, sink in
                context.connectedDeviceSink = sink
                return nil
            },
            onCancel: { context in
                context.connectedDeviceSink = nil
                return nil
            }
        )
    }

    var characteristicValueUpdateStreamHandler: StreamHandler<PluginController> {
        return StreamHandler(
            name: "characteristic value update stream handler",
            context: context,
            onListen: { context, sink in
                context.characteristicValueUpdateSink = sink
                context.messageQueue.forEach { msg in
                    sink.add(.success(msg))
                }
                context.messageQueue.removeAll()
                return nil
            },
            onCancel: { context in
                context.messageQueue.removeAll()
                context.characteristicValueUpdateSink = nil
                return nil
            }
        )
    }

    private let context = PluginController()

    private let methodHandler = MethodHandler<PluginController>([
        AnyPlatformMethod(NullaryPlatformMethod(name: "initialize") { name, context, completion in
            context.initialize(name: name, completion: completion)
        }),
        AnyPlatformMethod(NullaryPlatformMethod(name: "deinitialize") { name, context, completion in
            context.deinitialize(name: name, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "scanForDevices") { (name, context, args: ScanForDevicesRequest, completion) in
            context.scanForDevices(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "connectToDevice") { (name, context, args: ConnectToDeviceRequest, completion) in
            context.connectToDevice(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "disconnectFromDevice") { (name, context, args: ConnectToDeviceRequest, completion) in
            context.disconnectFromDevice(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "clearGattCache") { (name, context, args: ClearGattCacheRequest, completion) in
            let result = ClearGattCacheInfo.with {
                $0.failure = GenericFailure.with {
                    $0.code = Int32(ClearGattCacheFailure.operationNotSupported.rawValue)
                    $0.message = "Operation is not supported on iOS"
                }
            }
            completion(.success(result))
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "requestConnectionPriority") { (name, context, args: ChangeConnectionPriorityRequest, completion) in
            let result = ChangeConnectionPriorityInfo.with {
                $0.failure = GenericFailure.with {
                    $0.code = Int32(RequestConnectionPriorityFailure.operationNotSupported.rawValue)
                    $0.message = "Operation is not supported on iOS"
                }
            }
            completion(.success(result))
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "discoverServices") { (name, context, args: DiscoverServicesRequest, completion) in
            context.discoverServices(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "readNotifications") { (name, context, args: NotifyCharacteristicRequest, completion) in
            context.enableCharacteristicNotifications(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "stopNotifications") { (name, context, args: NotifyNoMoreCharacteristicRequest, completion) in
            context.disableCharacteristicNotifications(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "readCharacteristic") { (name, context, args: ReadCharacteristicRequest, completion) in
            context.readCharacteristic(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "writeCharacteristicWithResponse") { (name, context, args: WriteCharacteristicRequest, completion) in
            context.writeCharacteristicWithResponse(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "writeCharacteristicWithoutResponse") { (name, context, args: WriteCharacteristicRequest, completion) in
            context.writeCharacteristicWithoutResponse(name: name, args: args, completion: completion)
        }),
        AnyPlatformMethod(UnaryPlatformMethod(name: "negotiateMtuSize") { (name, context, args: NegotiateMtuRequest, completion) in
            context.reportMaximumWriteValueLength(name: name, args: args, completion: completion)
        }),
    ])

    public func handle(_ call: FlutterMethodCall, result completion: @escaping FlutterResult) {
        methodHandler.handle(in: context, call, completion: completion)
    }
}
