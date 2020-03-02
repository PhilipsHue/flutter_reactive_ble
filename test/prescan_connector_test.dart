import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_reactive_ble/src/model/connection_state_update.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/scan_mode.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/prescan_connector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRegistry extends Mock implements DiscoveredDevicesRegistry {}

abstract class _PrescanConnectorStub {
  Stream<ConnectionStateUpdate> connect(
      {String id,
      Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
      Duration connectionTimeout});

  Stream<DiscoveredDevice> scan({Uuid withService, ScanMode scanMode});

  ScanSession currentScan();
}

class _PreScanFunctionMock extends Mock implements _PrescanConnectorStub {}

void main() {
  PrescanConnector _sut;
  MockRegistry _registry;
  _PrescanConnectorStub _prescanMock;

  const _device = "test";
  final _uuid = Uuid.parse("123A");
  const _duration = Duration(milliseconds: 20);

  group("Given $PrescanConnector", () {
    setUp(() {
      _prescanMock = _PreScanFunctionMock();
      _registry = MockRegistry();
      _sut = PrescanConnector(
          scanRegistry: _registry,
          connectDevice: _prescanMock.connect,
          scanDevices: _prescanMock.scan,
          getCurrentScan: _prescanMock.currentScan,
          delayAfterScanFailure: _duration);

      when(_registry.isEmpty()).thenReturn(true);
    });

    group("And no current scan is running ", () {
      setUp(() {
        when(_prescanMock.currentScan()).thenReturn(null);
      });

      group("And device is in cache when I connect", () {
        setUp(() {
          when(_registry.deviceIsDiscoveredRecently(
                  deviceId: anyNamed("deviceId"),
                  cacheValidity: anyNamed("cacheValidity")))
              .thenReturn(true);

          _sut.connectToAdvertisingDevice(
              id: _device,
              withService: _uuid,
              prescanDuration: _duration,
              servicesWithCharacteristicsToDiscover: {},
              connectionTimeout: _duration);
        });

        test("Then connect device directly", () {
          verify(_prescanMock.connect(
                  id: anyNamed("id"),
                  servicesWithCharacteristicsToDiscover:
                      anyNamed("servicesWithCharacteristicsToDiscover"),
                  connectionTimeout: anyNamed("connectionTimeout")))
              .called(1);
        });

        test("And does not scan for the device", () {
          verifyNever(_prescanMock.scan(
              withService: anyNamed("withService"),
              scanMode: anyNamed("scanMode")));
        });
      });

      group("And device is not in cache", () {
        setUp(() {
          when(_registry.deviceIsDiscoveredRecently(
                  deviceId: anyNamed("deviceId"),
                  cacheValidity: anyNamed("cacheValidity")))
              .thenReturn(false);
        });

        group("And scan returns the device", () {
          Completer<void> completer;
          List<ScanSession> currentScanResponses;
          ScanSession session;

          setUp(() {
            completer = Completer();
            session = ScanSession(withService: _uuid, future: completer.future);

            when(_prescanMock.currentScan())
                .thenAnswer((_) => currentScanResponses.removeAt(0));
            completer.complete();

            when(_prescanMock.scan(
                    withService: anyNamed("withService"),
                    scanMode: anyNamed("scanMode")))
                .thenAnswer((_) => Stream.fromIterable([
                      DiscoveredDevice(
                        id: _device,
                        name: _device,
                        serviceData: const {},
                        manufacturerData: Uint8List(0),
                        rssi: -40,
                      )
                    ]));
          });

          test("It scans for the device", () {
            currentScanResponses = [null, session, session];

            _sut.connectToAdvertisingDevice(
                id: _device,
                withService: _uuid,
                prescanDuration: _duration,
                servicesWithCharacteristicsToDiscover: {},
                connectionTimeout: _duration);

            verify(_prescanMock.scan(
                    withService: anyNamed("withService"),
                    scanMode: anyNamed("scanMode")))
                .called(1);
          });

          test("Connects when device is in registry", () async {
            currentScanResponses = [session, session];

            final connectResponses = [false, true];
            when(_registry.deviceIsDiscoveredRecently(
                    deviceId: anyNamed("deviceId"),
                    cacheValidity: anyNamed("cacheValidity")))
                .thenAnswer((_) => connectResponses.removeAt(0));

            when(_prescanMock.connect(
                    id: anyNamed("id"),
                    servicesWithCharacteristicsToDiscover:
                        anyNamed("servicesWithCharacteristicsToDiscover"),
                    connectionTimeout: anyNamed("connectionTimeout")))
                .thenAnswer((_) => Stream.fromIterable([
                      const ConnectionStateUpdate(
                          deviceId: "",
                          connectionState: DeviceConnectionState.connected,
                          failure: null)
                    ]));

            await _sut
                .prescanAndConnect(_device, {}, _duration, _uuid, _duration)
                .first;

            verify(_prescanMock.connect(
                    id: anyNamed("id"),
                    servicesWithCharacteristicsToDiscover:
                        anyNamed("servicesWithCharacteristicsToDiscover"),
                    connectionTimeout: _duration))
                .called(1);
          });

          test("Does not connect when device is not found after scanning",
              () async {
            when(_registry.deviceIsDiscoveredRecently(
                    deviceId: anyNamed("deviceId"),
                    cacheValidity: anyNamed("cacheValidity")))
                .thenReturn(false);

            when(_prescanMock.connect(
                    id: anyNamed("id"),
                    servicesWithCharacteristicsToDiscover:
                        anyNamed("servicesWithCharacteristicsToDiscover"),
                    connectionTimeout: anyNamed("connectionTimeout")))
                .thenAnswer((_) => Stream.fromIterable([
                      const ConnectionStateUpdate(
                          deviceId: "",
                          connectionState: DeviceConnectionState.connected,
                          failure: null)
                    ]));

            await _sut
                .prescanAndConnect(_device, {}, _duration, _uuid, _duration)
                .first;

            verifyNever(_prescanMock.connect(
                id: anyNamed("id"),
                servicesWithCharacteristicsToDiscover:
                    anyNamed("servicesWithCharacteristicsToDiscover"),
                connectionTimeout: _duration));
          });
        });

        group("And scan fails", () {
          Completer<void> completer;

          setUp(() {
            completer = Completer();
            final session =
                ScanSession(withService: _uuid, future: completer.future);
            final response = [session, session];
            when(_prescanMock.currentScan())
                .thenAnswer((_) => response.removeAt(0));

            when(_prescanMock.scan(
                    withService: anyNamed("withService"),
                    scanMode: anyNamed("scanMode")))
                .thenAnswer((_) => Stream.fromIterable([
                      DiscoveredDevice(
                        id: _device,
                        name: _device,
                        serviceData: const {},
                        manufacturerData: Uint8List(0),
                        rssi: -40,
                      )
                    ]));
          });

          test("Will attempt to connect after delay", () async {
            when(_prescanMock.connect(
                    id: anyNamed("id"),
                    servicesWithCharacteristicsToDiscover:
                        anyNamed("servicesWithCharacteristicsToDiscover"),
                    connectionTimeout: anyNamed("connectionTimeout")))
                .thenAnswer((_) => Stream.fromIterable([
                      const ConnectionStateUpdate(
                          deviceId: "",
                          connectionState: DeviceConnectionState.connected,
                          failure: null)
                    ]));

            completer.completeError(null);

            await _sut
                .prescanAndConnect(_device, {}, _duration, _uuid, _duration)
                .first;

            verify(_registry.deviceIsDiscoveredRecently(
                    deviceId: anyNamed("deviceId"),
                    cacheValidity: anyNamed("cacheValidity")))
                .called(2);
          });
        });
      });
    });

    group("And there is already a scan running", () {
      test(
          "Fails to connect when there is already a scan running for another service",
          () async {
        when(_prescanMock.currentScan()).thenReturn(ScanSession(
            withService: Uuid.parse("432A"), future: Future.value()));

        final update = await _sut
            .awaitCurrentScanAndConnect(
                _uuid, _duration, _device, {}, _duration)
            .first;

        expect(update.failure.code, ConnectionError.failedToConnect);
      });

      test("Checks registry after completion of scan", () async {
        final completer = Completer<void>();

        when(_prescanMock.currentScan()).thenReturn(
            ScanSession(withService: _uuid, future: completer.future));

        when(_registry.deviceIsDiscoveredRecently(
                deviceId: anyNamed("deviceId"),
                cacheValidity: anyNamed("cacheValidity")))
            .thenReturn(false);

        completer.complete();
        await _sut
            .awaitCurrentScanAndConnect(
                _uuid, _duration, _device, {}, _duration)
            .first;

        verify(_registry.deviceIsDiscoveredRecently(
                deviceId: _device, cacheValidity: anyNamed("cacheValidity")))
            .called(1);
      });
    });
  });
}
