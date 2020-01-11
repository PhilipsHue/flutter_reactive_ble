import 'dart:async';

class SerialDisposable<T> {
  SerialDisposable(this._dispose);

  Future<void> set(T newValue) async {
    if (_isDisposed) {
      throw _SerialAlreadyDisposed(runtimeType);
    }
    if (_value != null) await _dispose(_value);
    _value = newValue;
    return newValue;
  }

  Future<void> dispose() async {
    _isDisposed = true;
    if (_value != null) {
      await _dispose(_value);
    }
  }

  bool get isDisposed => _isDisposed;

  final Future<void> Function(T) _dispose;
  bool _isDisposed = false;
  T _value;
}

class _SerialAlreadyDisposed extends Error {
  final Type _type;

  _SerialAlreadyDisposed(this._type);

  @override
  String toString() => "An instance of $_type has already been disposed";
}

class StreamSubscriptionSerialDisposable
    extends SerialDisposable<StreamSubscription> {
  StreamSubscriptionSerialDisposable()
      : super((StreamSubscription subscription) => subscription.cancel());
}
