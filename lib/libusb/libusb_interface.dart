import 'dart:typed_data';

import 'package:flutter_windows_utils/libusb/libusb_util.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_windows_utils/libusb/common.dart';

abstract class UsbPlatform extends PlatformInterface {
  UsbPlatform() : super(token: _token);

  static final Object _token = Object();

  static UsbPlatform _instance = UsbWindows();

  /// The default instance of [PathProviderPlatform] to use.
  ///
  /// Defaults to [MethodChannelPathProvider].
  static UsbPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PathProviderPlatform] when they register themselves.
  static set instance(UsbPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> init();

  Future<void> exit();

  Future<List<UsbDevice>> getDeviceList();

  Future<List<UsbDeviceDescription>> getDevicesWithDescription(
      {bool requestPermission = true});

  Future<UsbDeviceDescription> getDeviceDescription(UsbDevice usbDevice,
      {bool requestPermission = true});

  Future<bool> hasPermission(UsbDevice usbDevice);

  Future<bool> requestPermission(UsbDevice usbDevice);

  Future<bool> openDevice(UsbDevice usbDevice);

  Future<void> closeDevice();

  Future<UsbConfiguration> getConfiguration(int index);

  Future<bool> setConfiguration(UsbConfiguration config);

  Future<bool> claimInterface(UsbInterface intf);

  Future<bool> detachKernelDriver(UsbInterface intf);

  Future<bool> releaseInterface(UsbInterface intf);

  Future<Uint8List> bulkTransferIn(
      UsbEndpoint endpoint, int maxLength, int timeout);

  Future<int> bulkTransferOut(
      UsbEndpoint endpoint, Uint8List data, int timeout);

  Future<void> setAutoDetachKernelDriver(bool enable);
}
