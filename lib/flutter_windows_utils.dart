import 'package:flutter/services.dart';
import 'package:flutter_windows_utils/libusb/common.dart';
import 'package:flutter_windows_utils/libusb/libusb_interface.dart';

import 'flutter_windows_utils_platform_interface.dart';

export 'package:flutter_windows_utils/libusb/common.dart';

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

class FlutterWindowsBluetooth {
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

UsbPlatform get _platform => UsbPlatform.instance;

class FlutterWindowsUsb {
  static Future<bool> init() => _platform.init();

  static Future<void> exit() => _platform.exit();

  static Future<List<UsbDevice>> getDeviceList() => _platform.getDeviceList();

  /// [requestPermission] If true, Android will ask permission for each USB
  /// device if required. Only required to retrieve the serial number.
  static Future<List<UsbDeviceDescription>> getDevicesWithDescription({
    bool requestPermission = true,
  }) =>
      _platform.getDevicesWithDescription(requestPermission: requestPermission);

  /// [requestPermission] If true, Android will ask permission for the USB device
  /// if required. Only required to retrieve the serial number.
  static Future<UsbDeviceDescription> getDeviceDescription(
    UsbDevice usbDevice, {
    bool requestPermission = true,
  }) =>
      _platform.getDeviceDescription(
        usbDevice,
        requestPermission: requestPermission,
      );

  static Future<bool> hasPermission(UsbDevice usbDevice) =>
      _platform.hasPermission(usbDevice);

  static Future<bool> requestPermission(UsbDevice usbDevice) =>
      _platform.requestPermission(usbDevice);

  static Future<bool> openDevice(UsbDevice usbDevice) =>
      _platform.openDevice(usbDevice);

  static Future<void> closeDevice() => _platform.closeDevice();

  static Future<UsbConfiguration> getConfiguration(int index) =>
      _platform.getConfiguration(index);

  static Future<bool> setConfiguration(UsbConfiguration config) =>
      _platform.setConfiguration(config);

  static Future<bool> detachKernelDriver(UsbInterface intf) =>
      _platform.detachKernelDriver(intf);

  static Future<bool> claimInterface(UsbInterface intf) =>
      _platform.claimInterface(intf);

  static Future<bool> releaseInterface(UsbInterface intf) =>
      _platform.releaseInterface(intf);

  static Future<Uint8List> bulkTransferIn(UsbEndpoint endpoint, int maxLength,
          {int timeout = 1000}) =>
      _platform.bulkTransferIn(endpoint, maxLength, timeout);

  static Future<int> bulkTransferOut(UsbEndpoint endpoint, Uint8List data,
          {int timeout = 1000}) =>
      _platform.bulkTransferOut(endpoint, data, timeout);

  static Future<void> setAutoDetachKernelDriver(bool enable) =>
      _platform.setAutoDetachKernelDriver(enable);
}
