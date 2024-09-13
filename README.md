## LanMixed

A lightweight UDP-based LAN communication plugin that supports multicast and unicast, allowing data to be sent and received within a local network.

Since UDP is a connectionless protocol, this plugin does not guarantee reliable data transmission.

### Preview
![App preview](https://raw.githubusercontent.com/aiyakuaile/lan_mixed/main/preview.png)

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: |:---:| :---: | :-----: |
|   ✅    | ✅  |  ✅   |  ❌  |  ✅   |   ✅    |

## Requirements

- Flutter >=3.3.0
- Dart >=3.3.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

### Usage
```yaml
dependencies:
  ...
  lan_mixed: ^0.0.1
```

```dart
import 'package:lan_mixed/lan_mixed.dart';
```
### Creating an Instance
```dart
final lanMixed = LanMixed();
```

### Starting the Service
```dart
    lanMixed.startService(
      port: port,
      onReceiveMsg: (msg) {},
      onDevicesChange: (devices) {},
    );
```

### Sending a Message
```dart
lanMixed.sendMessage();
```
### Stopping the Service
```dart
lanMixed.close();
```

## Refreshing Online Devices
```dart
lanMixed.refreshDevices();
```

> This project depends on other third-party plugins. For more details, refer to：
> - [network_info_plus](https://pub.dev/packages/network_info_plus)
> - [device_info_plus](https://pub.dev/packages/device_info_plus)