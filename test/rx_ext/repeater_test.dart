import 'dart:async';

import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Repeater", () {
    StreamController<int> underlyingStreamController;
    _RepeaterHandlerMock<int> handler;

    setUp(() {
      underlyingStreamController = StreamController(sync: true);
      handler = _RepeaterHandlerMock();
    });

    tearDown(() {
      underlyingStreamController.close();
    });

    group('Repeater internals', () {
      Repeater<int> sut;

      setUp(() {
        sut = Repeater(
          onListenEmitFrom: handler.onListenEmitFrom,
          onCancel: handler.onCancel,
          isSync: true,
        );
        when(handler.onListenEmitFrom())
            .thenAnswer((_) => underlyingStreamController.stream);
      });

      test(
          "does not subscribe to the underlying stream in absence of listeners",
          () {
        verifyNever(handler.onListenEmitFrom());
      });

      test("subscribes to the underlying stream when a listener connects", () {
        sut.stream.listen((_) {});

        verify(handler.onListenEmitFrom()).called(1);
        expect(underlyingStreamController.hasListener, true);
      });

      test("subscribes to the underlying stream when attached", () {
        sut.detach();
        sut.stream.listen((_) {});
        sut.attach();

        verify(handler.onListenEmitFrom()).called(1);
        expect(underlyingStreamController.hasListener, true);
      });

      test(
          "unsubscribes from the underlying stream when there are no listeners left",
          () async {
        await sut.stream.listen((_) {}).cancel();

        verify(handler.onCancel()).called(1);
        expect(underlyingStreamController.hasListener, false);
      });

      test("unsubscribes from the underlying stream when detached", () async {
        sut.stream.listen((_) {});
        await sut.detach();

        verify(handler.onCancel()).called(1);
        expect(underlyingStreamController.hasListener, false);
      });

      test("unsubscribes from the underlying stream when disposed", () async {
        sut.stream.listen((_) {});
        await sut.dispose();

        verify(handler.onCancel()).called(1);
        expect(underlyingStreamController.hasListener, false);
      });

      test("safely disposes when has not been listened to", () {
        expect(() async => sut.dispose(), returnsNormally);
      });
    });

    group('Broadcast repeater', () {
      Repeater<int> sut;

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

      setUp(() {
        sut = Repeater.fromStream(underlyingStreamController.stream);
      });

      test('It subscribes to stream supplied in constructor', () {
        sut.stream.listen((_) {});

        expect(underlyingStreamController.hasListener, true);
      });

      test('It pauses the stream when pause is called', () async {
        sut.stream.listen((_) {}).pause();
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

class _RepeaterHandlerMock<T> extends Mock implements _RepeaterHandler<T> {}

abstract class _RepeaterHandler<T> {
  Stream<T> onListenEmitFrom();

  Future<dynamic> onCancel();
}
