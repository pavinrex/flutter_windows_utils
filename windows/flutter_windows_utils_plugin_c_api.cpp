#include "include/flutter_windows_utils/flutter_windows_utils_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_windows_utils_plugin.h"

void FlutterWindowsUtilsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_windows_utils::FlutterWindowsUtilsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
