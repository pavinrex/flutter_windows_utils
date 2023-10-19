import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_windows_utils_platform_interface.dart';

class BTList {
  String? name;
  String? address;
}

/// An implementation of [FlutterWindowsUtilsPlatform] that uses method channels.
class MethodChannelFlutterWindowsUtils extends FlutterWindowsUtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_windows_utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<Map<String, dynamic>>> getBTDevices() async {
    final devices =
        await methodChannel.invokeMethod<List<dynamic>>('getbtdevices');
    var result = devices!
        .cast<Map<dynamic, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return result;
  }

  @override
  Future<void> writeBytes(
    String address,
    int port,
    Uint8List bytes_send,
  ) async {
    print("test 1");
    methodChannel.invokeMethod('sendBytes', {
      'address': address,
      'port': port,
      'bytes': bytes_send,
    }).then((_) {
      print("test 2");
      // _log('writeValue invokeMethod success', logLevel: Level.ALL);
    }).catchError((onError) {
      // Characteristic sometimes unavailable on Android
      // throw onError;
      print(onError);
    });
  }
}
