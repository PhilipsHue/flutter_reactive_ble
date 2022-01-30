import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

///This is initial version of `Flutter_reactive_ble` library for `Web` version
///this demo is using `GETX` as State Management
///Main Code for Connection With `BluetoothDevice` is in app/modules/home/home_controller.dart

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Reactive Ble",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
