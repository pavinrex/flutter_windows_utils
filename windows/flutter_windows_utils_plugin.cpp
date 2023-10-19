#include <winsock2.h>
#include "flutter_windows_utils_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>
#include <ws2bth.h>
#include <bluetoothapis.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <iomanip>
#include <sstream>


#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "Bthprops.lib")

namespace flutter_windows_utils {

    using flutter::EncodableValue;
    using flutter::EncodableMap;
    using flutter::EncodableList;


    class Bluetooth {
    public:
        static std::string ba2str(BTH_ADDR bthAddr) {
            std::ostringstream oss;
            oss << std::hex << std::setfill('0') << std::setw(12) << bthAddr;
            std::string result = oss.str();

            // Insert colons or other separators as needed
            result.insert(10, ":");
            result.insert(8, ":");
            result.insert(6, ":");
            result.insert(4, ":");
            result.insert(2, ":");

            return result;
        }

        static BTH_ADDR str2ba(const char* straddr)
        {
            int i;
            BTH_ADDR btaddr = 0;
            unsigned int aaddr[6];
            BTH_ADDR tmpaddr = 0;

            if (sscanf_s(straddr, "%02x:%02x:%02x:%02x:%02x:%02x",
                &aaddr[0], &aaddr[1], &aaddr[2],
                &aaddr[3], &aaddr[4], &aaddr[5]) != 6)
                return 1;
            btaddr = 0;
            for (i = 0; i < 6; i++) {
                tmpaddr = (BTH_ADDR)(aaddr[i] & 0xff);
                btaddr = ((btaddr) << 8) + tmpaddr;
            }
            return btaddr;
        }

        static std::string wchar2string(WCHAR *wideStr) {

            int wideStrLength = (int)wcslen(wideStr);
            int bufferSize = WideCharToMultiByte(CP_UTF8, 0, wideStr, wideStrLength, NULL, 0, NULL, NULL);
            char* narrowStr = new char[bufferSize + 1];
            WideCharToMultiByte(CP_UTF8, 0, wideStr, wideStrLength, narrowStr, bufferSize, NULL, NULL);
            narrowStr[bufferSize] = '\0';
            std::string narrowString(narrowStr);
            delete[] narrowStr;
            return narrowString;

        }

        static int listBTDevices(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> &result) {
            WSADATA wsaData;
            if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
                std::cerr << "WSAStartup failed" << std::endl;
                result->Error("Bluetooth Start Error");
                return 1;
            }

            // Discover available Bluetooth devices
            BLUETOOTH_DEVICE_SEARCH_PARAMS searchParams = { sizeof(BLUETOOTH_DEVICE_SEARCH_PARAMS) };
            searchParams.fReturnAuthenticated = true;
            searchParams.fReturnRemembered = true;
            searchParams.fReturnConnected = true;
            searchParams.fReturnUnknown = true;
            searchParams.fIssueInquiry = true;
            searchParams.cTimeoutMultiplier = 4;
            searchParams.hRadio = NULL;

            BLUETOOTH_DEVICE_INFO deviceInfo = { sizeof(BLUETOOTH_DEVICE_INFO) };
            deviceInfo.Address.ullLong = 0;

            HANDLE hDeviceFind = BluetoothFindFirstDevice(&searchParams, &deviceInfo);
            std::vector<BLUETOOTH_DEVICE_INFO> devices;
            //std::map<flutter::EncodableValue, flutter::EncodableValue> tmp_device;
            //std::vector<flutter::EncodableValue> devices_f;
            flutter::EncodableMap mapData;
            flutter::EncodableList list;
            
            if (hDeviceFind != NULL) {
                do {
                    devices.push_back(deviceInfo);
                    //OutputDebugString((L"Device Name " + winrt::to_hstring(deviceInfo.szName) + L"\n").c_str());
                    //wprintf(L"Device Name: %s\n", deviceInfo.szName);
                    //wprintf(L"Device Address: %I64x\n\n", deviceInfo.Address.ullLong);
                    mapData[flutter::EncodableValue("name")] = flutter::EncodableValue(wchar2string(deviceInfo.szName));
                    mapData[flutter::EncodableValue("address")] = flutter::EncodableValue(ba2str(deviceInfo.Address.ullLong));
                    list.push_back(flutter::EncodableValue(mapData));
                    std::string lt = wchar2string(deviceInfo.szName);
                    std::cout << "Name string : " << lt << "\n";
                    std::cout << ba2str(deviceInfo.Address.ullLong) << "\n";
                } while (BluetoothFindNextDevice(hDeviceFind, &deviceInfo));
                BluetoothFindDeviceClose(hDeviceFind);
            }
            else {
                std::cerr << "No Bluetooth devices found" << std::endl;
                WSACleanup();
                result->Error("No Bluetooth devices found");
                return 1;
            }

            WSACleanup();

            result->Success(list);

            return 0;
        }


        static int bt_write_data(std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>& result, std::string address, int port, std::vector<uint8_t> bytes_send) {
            WSADATA wsaData;
            if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
                std::cerr << "WSAStartup failed" << std::endl;
                result->Error("Bluetooth Start Error");
                return 1;
            }

            SOCKET s = socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
            if (s == INVALID_SOCKET) {
                std::cerr << "Socket creation failed" << std::endl;
                result->Error("Socket creation failed");
                WSACleanup();
                return 1;
            }

            SOCKADDR_BTH addr = { 0 };
            addr.addressFamily = AF_BTH;
            addr.btAddr = str2ba(address.c_str());
            addr.port = port;

            if (connect(s, (struct sockaddr*)&addr, sizeof(addr)) == SOCKET_ERROR) {
                std::cerr << "Error connecting to the device" << std::endl;
                DWORD error = GetLastError();
                LPVOID errorMsg;
                FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM, NULL, error, 0, (LPTSTR)&errorMsg, 0, NULL);
                //wprintf(L"Error: %s\n", &errorMsg);
                LocalFree(errorMsg);
                closesocket(s);
                WSACleanup();
                result->Error("Error connecting to the device");
                return 1;
            }

            // Data to send
            ///const char* message = "Hello, World";

            // Send data to the device
            //int send_result = send(s, message, (int)strlen(message), 0);
            //int send_result = send(s, reinterpret_cast<const char*>(bytes_send.data()), bytes_send.size() * sizeof(uint8_t), 0);
            //if (send_result == SOCKET_ERROR) {
            //    std::cerr << "Error sending data" << std::endl;
            //    result->Error("Error sending data");
            //}
            //else {
            //    result->Success("OK");
            //}

            size_t totalSize = bytes_send.size();

            // Send the data in 500-byte chunks
            size_t bytesSent = 0;
            while (bytesSent < totalSize) {
                size_t chunkSize = (((totalSize - bytesSent) < (size_t(500))) ? (totalSize - bytesSent) : (size_t(500)));
                int send_result = send(s, reinterpret_cast<const char*>(bytes_send.data() + bytesSent), static_cast<int>(chunkSize), 0);

                if (send_result == SOCKET_ERROR) {
                    std::cerr << "Send failed." << std::endl;
                    result->Error("Error sending data");
                    break;
                }
                else {
                    std::cout << "Sent " << send_result << " bytes." << std::endl;
                    bytesSent += static_cast<size_t>(send_result);
                }
            }

            result->Success(nullptr);
            // Close the Bluetooth socket
            closesocket(s);

            // Clean up Winsock
            WSACleanup();

            return 0;
        }

    };

 



// static
void FlutterWindowsUtilsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_windows_utils",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterWindowsUtilsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FlutterWindowsUtilsPlugin::FlutterWindowsUtilsPlugin() {}

FlutterWindowsUtilsPlugin::~FlutterWindowsUtilsPlugin() {}

void FlutterWindowsUtilsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto method_name = method_call.method_name();
  if (method_name.compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  }
  else if (method_name.compare("getbtdevices") == 0)
  {
      Bluetooth::listBTDevices(result);
  }
  else if (method_name.compare("sendBytes") == 0) {
      auto args = std::get<EncodableMap>(*method_call.arguments());
      auto address = std::get<std::string>(args[EncodableValue("address")]);
      auto port = std::get<int>(args[EncodableValue("port")]);
      auto bytes_ut = std::get<std::vector<uint8_t>>(args[EncodableValue("bytes")]);

      Bluetooth::bt_write_data(result, address, port, bytes_ut);
  }
  else {
    result->NotImplemented();
  }
}

}  // namespace flutter_windows_utils
