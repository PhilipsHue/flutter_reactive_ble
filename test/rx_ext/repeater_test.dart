import 'dart:async';

import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Repeater", () {
    late StreamController<int> underlyingStreamController;
    late _RepeaterHandler<int> handler;

    setUp(() {
      underlyingStreamController = StreamController(sync: true);
      handler = _RepeaterHandler(underlyingStreamController.stream);
    });

    tearDown(() {
      underlyingStreamController.close();
    });

    group('Repeater internals', () {
      late Repeater<int> sut;

      setUp(() {
        sut = Repeater(
          onListenEmitFrom: handler.onListenEmitFrom,
          onCancel: handler.onCancel,
          isSync: true,
        );
      });
      group('Has subscription', () {
        late StreamSubscription<int> subscription;

        setUp(() {
          subscription = sut.stream.listen((_) {});
        });

        test("subscribes to the underlying stream when a listener connects",
            () {
          expect(underlyingStreamController.hasListener, true);
        });
        test(
            "unsubscribes from the underlying stream when there are no listeners left",
            () async {
          await subscription.cancel();

          expect(underlyingStreamController.hasListener, false);
        });

        test("unsubscribes from the underlying stream when detached", () async {
          await sut.detach();

          expect(underlyingStreamController.hasListener, false);
        });

        test("unsubscribes from the underlying stream when disposed", () async {
          await sut.dispose();

          expect(underlyingStreamController.hasListener, false);
        });

        test("safely disposes when has not been listened to", () {
          expect(() async => sut.dispose(), returnsNormally);
        });
      });
    });

    group('Broadcast repeater', () {
      late Repeater<int> sut;

      setUp(() {
        sut = Repeater.broadcast(
          onListenEmitFrom: handler.onListenEmitFrom,
          onCancel: handler.onCancel,
          isSync: true,
        );
      });

      test('It converts non broadcast stream to abroadcast stream', () {
        expect(sut.stream.isBroadcast, true);
      });
    });

    group('Repeater from stream', () {
      Repeater<int> sut;
      late StreamSubscription<int> subscription;

      setUp(() {
        sut = Repeater.fromStream(underlyingStreamController.stream);
        subscription = sut.stream.listen((_) {});
      });

      tearDown(() async {
        await subscription.cancel();
      });

      test('It subscribes to stream supplied in constructor', () {
        expect(underlyingStreamController.hasListener, true);
      });

      test('It pauses the stream when pause is called', () async {
        subscription.pause();
        expect(underlyingStreamController.isPaused, true);
      });

      test(
          'Repeater returns broadcast stream in case source is a broadcast stream',
          () {
        sut = Repeater.fromStream(
            underlyingStreamController.stream.asBroadcastStream());

        expect(sut.stream.isBroadcast, true);
      });
    });
  });
}

class _RepeaterHandler<T> {
  const _RepeaterHandler(Stream<T> stream) : _stream = stream;
  final Stream<T> _stream;
  Stream<T> onListenEmitFrom() => _stream;

  Future<dynamic> onCancel() async {}
}
