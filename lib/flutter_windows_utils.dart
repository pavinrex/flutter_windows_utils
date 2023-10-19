import 'package:flutter/services.dart';

import 'flutter_windows_utils_platform_interface.dart';

class FlutterWindowsUtils {
  Future<String?> getPlatformVersion() {
    return FlutterWindowsUtilsPlatform.instance.getPlatformVersion();
  }

  static Future<List<Map<String, dynamic>>> getBluetoothDevices() {
    return FlutterWindowsUtilsPlatform.instance.getBTDevices();
  }

  static Future<void> writeBytes(
    String address,
    int port,
    Uint8List bytes_send,
  ) {
    return FlutterWindowsUtilsPlatform.instance
        .writeBytes(address, port, bytes_send);
  }
}
