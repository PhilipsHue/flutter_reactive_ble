import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Serialdisposable', () {
    SerialDisposable<int> sut;
    _DisposerMock disposer;

    setUp(() {
      disposer = _DisposerMock();
      sut = SerialDisposable(disposer.dispose);
    });
    test('It emits last set value on dispose', () async {
      await sut.set(5);
      await sut.dispose();
      verify(disposer.dispose(5)).called(1);
    });

    test('It disposes previous value when a new value is set', () async {
      await sut.set(4);
      await sut.set(5);
      verify(disposer.dispose(4)).called(1);
    });

    test('It dnever calls dispose method in case no value is set', () async {
      await sut.dispose();
      verifyNever(disposer.dispose(any));
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

abstract class _Disposer {
  Future<void> dispose(int value);
}

class _DisposerMock extends Mock implements _Disposer {}
