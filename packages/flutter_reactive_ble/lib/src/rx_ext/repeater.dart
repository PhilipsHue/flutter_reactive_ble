import 'dart:async';

import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

/// [Repeater] sets an underlying stream up on the first subscription to
/// the output [stream] and shuts it down when there are no more subscriptions.
///
/// The underlying stream can be manually shut down by calling [detach] and set
/// up again by calling [attach] without terminating the existing subscriptions
/// to the output stream.
class Repeater<T> {
  final Stream<T> Function() _onListenEmitFrom;
  final Future<dynamic> Function()? _onCancel;
  final bool _isSync;
  final bool _isBroadcast;
  int detachCount = 0;

  // ignore: prefer_function_declarations_over_variables
  void Function(String) log = (_) {};

  StreamController<T>? _streamController;
  StreamSubscription<T>? _sourceSubscription;

  /// The output stream.
  Stream<T> get stream =>
      (_streamController ??= _makeStreamController()).stream;

  /// Resumes forwarding events from the source stream.
  ///
  /// Normally called automatically when the `stream` gets the first subscription.
  /// You may want to call this method manually after a call to `detach()`.
  void attach() {
    assert(detachCount >= 0,
        "A call to `attach()` should follow a call to `detach()` (nesting is allowed)");
    detachCount -= 1;

    if (detachCount < 0 &&
        _streamController!.hasListener &&
        _sourceSubscription == null) {
      log("ATTACH");
      try {
        _sourceSubscription = _onListenEmitFrom().listen(
          _streamController!.add,
          onError: _streamController!.addError,
          onDone: _streamController!.close,
        );
      } on Exception catch (e, s) {
        _streamController!.addError(e, s);
      }
    }
  }

  /// Stops forwarding events from the source stream.
  ///
  /// Normally called automatically when the `stream` looses the last subscription.
  Future<void> detach() async {
    detachCount += 1;

    if ((detachCount >= 0 || !_streamController!.hasListener) &&
        _sourceSubscription != null) {
      log("DETACH");
      await _sourceSubscription!.cancel();
      _sourceSubscription = null;

      if (_onCancel != null) {
        await _onCancel!();
      }
    }
  }

  /// Closes the `stream`.
  Future<Unit> dispose() async {
    await _streamController?.close();
    return const Unit();
  }

  Repeater({
    required Stream<T> Function() onListenEmitFrom,
    Future<dynamic> Function()? onCancel,
    bool isSync = false,
  })  : _onListenEmitFrom = onListenEmitFrom,
        _onCancel = onCancel,
        _isBroadcast = false,
        _isSync = isSync;

  Repeater.broadcast({
    required Stream<T> Function() onListenEmitFrom,
    Future<dynamic> Function()? onCancel,
    bool isSync = false,
  })  : _onListenEmitFrom = onListenEmitFrom,
        _onCancel = onCancel,
        _isBroadcast = true,
        _isSync = isSync;

  factory Repeater.fromStream(Stream<T> source,
          {Future<dynamic> Function()? onCancel, bool isSync = false}) =>
      source.isBroadcast
          ? Repeater.broadcast(
              onListenEmitFrom: () => source,
              onCancel: onCancel,
              isSync: isSync)
          : Repeater(
              onListenEmitFrom: () => source,
              onCancel: onCancel,
              isSync: isSync);

  // ignore: avoid_shadowing_type_parameters
  StreamController<T> _makeStreamController<T>() => _isBroadcast
      ? StreamController.broadcast(
          onListen: attach,
          onCancel: detach,
          sync: _isSync,
        )
      : StreamController(
          onListen: attach,
          onPause: () => _sourceSubscription?.pause(),
          onResume: () => _sourceSubscription?.resume(),
          onCancel: detach,
          sync: _isSync,
        );
}
