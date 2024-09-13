## LanMixed

一款轻量级的基于UDP协议的局域网通信插件，支持多播和单播，可在局域网内发送和接收数据。

由于UDP协议是无连接的，所以无法保证数据的可靠传输，故本插件不保证数据的可靠传输。

### 预览
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

### 使用
```yaml
dependencies:
  ...
  lan_mixed: ^0.0.1
```

```dart
import 'package:lan_mixed/lan_mixed.dart';
```
### 创建实例
```dart
final lanMixed = LanMixed();
```

### 开启服务
```dart
    lanMixed.startService(
      port: port,
      onReceiveMsg: (msg) {},
      onDevicesChange: (devices) {},
    );
```

### 发送消息
```dart
lanMixed.sendMessage();
```
### 停止服务
```dart
lanMixed.close();
```

## 刷新在线设备
```dart
lanMixed.refreshDevices();
```

> 本项目依赖其他第三方插件，具体使用请参考：
> - [network_info_plus](https://pub.dev/packages/network_info_plus)
> - [device_info_plus](https://pub.dev/packages/device_info_plus)