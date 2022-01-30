import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Reactive Ble'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ///`Top Buttons`
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      controller.scanBluetoothDevice();
                    },
                    child: Text('Scan Device')),
                Obx(() => ElevatedButton(
                    onPressed: () {
                      controller.bluetoothStatus();
                    },
                    child: Text(
                        'Bluetooth Status :  ${controller.bleStatusText.value}'))),
              ],
            ),
          ),
          Divider(),

          ///List of `Bluetooth Devices`
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.discoveredDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        ///When User Click on A Device
                        controller
                            .connectDevice(controller.discoveredDevices[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.bluetooth),
                            title:
                                Text(controller.discoveredDevices[index].name),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
