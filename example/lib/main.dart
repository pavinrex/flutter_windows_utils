import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_windows_utils/flutter_windows_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterWindowsUtilsPlugin = FlutterWindowsUtils();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      platformVersion = await _flutterWindowsUtilsPlugin.getPlatformVersion() ??
          'Unknown platform version';

      // final devices = await FlutterWindowsUtils.getBluetoothDevices();
      // print("devices");
      // print(devices);

      List<int> list = utf8.encode("Hello, World. It works");
      // List<int> list = List.generate(1000, (index) => 1);
      Uint8List bytes = Uint8List.fromList(list);
      await FlutterWindowsUtils.writeBytes("00:02:0a:01:bd:01", 1, bytes);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    } catch (e) {
      platformVersion = 'Failed to get platform version.';
      print("Error");
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
