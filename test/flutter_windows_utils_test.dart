import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_windows_utils/flutter_windows_utils.dart';
import 'package:flutter_windows_utils/flutter_windows_utils_platform_interface.dart';
import 'package:flutter_windows_utils/flutter_windows_utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWindowsUtilsPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWindowsUtilsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWindowsUtilsPlatform initialPlatform = FlutterWindowsUtilsPlatform.instance;

  test('$MethodChannelFlutterWindowsUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWindowsUtils>());
  });

  test('getPlatformVersion', () async {
    FlutterWindowsUtils flutterWindowsUtilsPlugin = FlutterWindowsUtils();
    MockFlutterWindowsUtilsPlatform fakePlatform = MockFlutterWindowsUtilsPlatform();
    FlutterWindowsUtilsPlatform.instance = fakePlatform;

    expect(await flutterWindowsUtilsPlugin.getPlatformVersion(), '42');
  });
}
