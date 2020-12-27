# Flutter reactive BLE UART demo app

This demo app shows a use case for using flutter_reactive_ble library for building a UART emulation over BLE.

This demo app uses one service: the Nordic UART Service with vendor-specific UUID:

```dart
Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
```

The aforementioned service uses two characteristics: one for transmitting and one for receiving (as seen from the peer).

```dart
Uuid _UART_RX   = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_TX   = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");
```

## Usage

This app can be used if the BLE peripheral implements the aforementioned services. The user interface is shown below:

![Screenshot](./screenshot.png "User interface")

Use the play button for scanning and the stop button for stop a running scan. When an UART BLE service is found, it is displayed at the top. Press the found device at the right, then a connection is being established as can be seen in the Status messages pane. Then a message string can be sent to the BLE peripheral, Received data is shown in the Received data pane. An existing connection can be closed using the bottom rightmost button.

## BLE undeliverable exception

The BLE undeliverable exception is handled as shown in [this file.](./android/app/src/main/kotlin/com/example/ble_testapp/MainActivity.kt)

quite
