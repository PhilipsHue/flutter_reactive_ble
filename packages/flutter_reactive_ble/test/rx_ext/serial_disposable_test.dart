import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Serialdisposable', () {
    late SerialDisposable<int> sut;
    late _Disposer disposer;

    setUp(() {
      disposer = _Disposer();
      sut = SerialDisposable(disposer.dispose);
    });
    test('It emits last set value on dispose', () async {
      await sut.set(5);
      await sut.dispose();
      expect(disposer.disposedValues, [5]);
    });

    test('It disposes previous value when a new value is set', () async {
      await sut.set(4);
      await sut.set(5);
      expect(disposer.disposedValues, [4]);
    });

    test('It never calls dispose method in case no value is set', () async {
      await sut.dispose();
      expect(disposer.disposedValues, isEmpty);
    });

    test('It returns false in case it is not disposed', () async {
      await sut.set(4);
      expect(sut.isDisposed, false);
    });

    test('It returns true in case it is disposed', () async {
      await sut.set(4);
      await sut.dispose();
      expect(sut.isDisposed, true);
    });

    test('It throws in case setting a value on already disposed disposable',
        () async {
      await sut.dispose();
      expect(sut.set(4), throwsA(anything));
    });
  });
}

class _Disposer {
  final _values = <int>[];
  Future<Unit> dispose(int value) async {
    _values.add(value);
    return const Unit();
  }

  List<int> get disposedValues => _values;
}
