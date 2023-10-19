import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_windows_utils_method_channel.dart';

abstract class FlutterWindowsUtilsPlatform extends PlatformInterface {
  /// Constructs a FlutterWindowsUtilsPlatform.
  FlutterWindowsUtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWindowsUtilsPlatform _instance =
      MethodChannelFlutterWindowsUtils();

  /// The default instance of [FlutterWindowsUtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWindowsUtils].
  static FlutterWindowsUtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWindowsUtilsPlatform] when
  /// they register themselves.
  static set instance(FlutterWindowsUtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getBTDevices() {
    throw UnimplementedError('getBTDevices() has not been implemented.');
  }

  Future<void> writeBytes(
    String address,
    int port,
    Uint8List bytes_send,
  ) {
    throw UnimplementedError('writeBytes() has not been implemented.');
  }
}
