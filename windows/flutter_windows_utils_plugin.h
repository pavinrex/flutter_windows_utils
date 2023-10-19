#ifndef FLUTTER_PLUGIN_FLUTTER_WINDOWS_UTILS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_WINDOWS_UTILS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_windows_utils {

class FlutterWindowsUtilsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterWindowsUtilsPlugin();

  virtual ~FlutterWindowsUtilsPlugin();

  // Disallow copy and assign.
  FlutterWindowsUtilsPlugin(const FlutterWindowsUtilsPlugin&) = delete;
  FlutterWindowsUtilsPlugin& operator=(const FlutterWindowsUtilsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_windows_utils

#endif  // FLUTTER_PLUGIN_FLUTTER_WINDOWS_UTILS_PLUGIN_H_
