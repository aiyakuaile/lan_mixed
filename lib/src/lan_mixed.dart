import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:lan_mixed/src/lan_msg_entity.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LanMixed {
  factory LanMixed() {
    _singleton ??= LanMixed._();
    return _singleton!;
  }

  static LanMixed? _singleton;

  LanMixed._() {
    _deviceInfo = DeviceInfoPlugin();
    _deviceType = Platform.operatingSystem;
  }

  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfo!.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfo!.iosInfo;
      return iosInfo.name;
    } else if (Platform.isWindows) {
      var windowInfo = await _deviceInfo!.windowsInfo;
      return windowInfo.userName;
    } else if (Platform.isMacOS) {
      var macOsInfo = await _deviceInfo!.macOsInfo;
      return macOsInfo.computerName;
    } else {
      return 'unknown';
    }
  }

  DeviceInfoPlugin? _deviceInfo;

  DeviceInfoPlugin? get deviceInfo => _deviceInfo;
  String? _deviceName;
  String? _deviceType;

  String? get deviceName => _deviceName;

  String? get deviceType => _deviceType;
  String? _deviceIP;

  String? get deviceIP => _deviceIP;
  int? _port;

  int? get port => _port;
  RawDatagramSocket? _socket;

  final List<DeviceEntity> _devices = [];

  ValueChanged<List<DeviceEntity>>? _onDevicesChange;

  void startService(
      {required int port,
      required ValueChanged<LanMsgEntity> onReceiveMsg,
      required ValueChanged<List<DeviceEntity>> onDevicesChange,
      bool isTV = false}) async {
    if (_socket != null) close();
    _deviceIP = await NetworkInfo().getWifiIP();
    if (_deviceIP == null) {
      throw Exception('Unable to obtain IP address::::');
    }
    _port = port;
    _onDevicesChange = onDevicesChange;
    if (isTV) _deviceType = '$_deviceType TV';
    _deviceName = await getDeviceName();
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket!.broadcastEnabled = true;
    _socket!.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket!.receive();
        if (datagram != null) {
          String message = utf8.decode(datagram.data);
          String remoteAddress = datagram.address.address;
          debugPrint('remoteIp:::$remoteAddress======localIp=$_deviceIP');
          if (remoteAddress != _deviceIP) {
            final receiveMsg = LanMsgEntity.fromJson(json.decode(message));
            switch (receiveMsg.type) {
              case -1:
                _devices.removeWhere(
                    (e) => e.deviceIp == receiveMsg.device!.deviceIp!);
                onDevicesChange(_devices);
                break;
              case 0:
                _broadcastMessage(
                    LanMsgEntity(
                      type: 2,
                      device: DeviceEntity(
                        deviceIp: _deviceIP,
                        deviceName: _deviceName,
                        deviceType: _deviceType,
                      ),
                    ),
                    receiveMsg.device!.deviceIp!);
                final index = _devices
                    .indexWhere((element) => element.deviceIp == remoteAddress);
                if (index == -1) {
                  _devices.add(receiveMsg.device!);
                  onDevicesChange(_devices);
                }
                break;
              case 1:
                onReceiveMsg(receiveMsg);
                break;
              case 2:
                final index = _devices.indexWhere((element) =>
                    element.deviceIp == receiveMsg.device!.deviceIp!);
                if (index == -1) {
                  _devices.add(receiveMsg.device!);
                  onDevicesChange(_devices);
                }
                break;
              case 3:
                _broadcastMessage(
                    LanMsgEntity(
                      type: 0,
                      device: DeviceEntity(
                        deviceIp: _deviceIP,
                        deviceName: _deviceName,
                        deviceType: _deviceType,
                      ),
                    ),
                    remoteAddress);
                break;
            }
          }
        }
      }
    });
    _broadcastMessage(
      LanMsgEntity(
        type: 0,
        device: DeviceEntity(
          deviceIp: _deviceIP,
          deviceName: _deviceName,
          deviceType: _deviceType,
        ),
      ),
    );
  }

  void close() {
    _broadcastMessage(
      LanMsgEntity(
        type: -1,
        device: DeviceEntity(
          deviceIp: _deviceIP,
          deviceName: _deviceName,
          deviceType: _deviceType,
        ),
      ),
    );
    _socket?.close();
    _socket = null;
  }

  void _broadcastMessage(LanMsgEntity msg,
      [String address = '255.255.255.255']) {
    final message = json.encode(msg.toJson());
    List<int> data = utf8.encode(message);
    _socket?.send(data, InternetAddress(address), _port!);
  }

  void sendMessage(String data, [String address = '255.255.255.255']) {
    _broadcastMessage(
      LanMsgEntity(
        type: 1,
        device: DeviceEntity(
          deviceIp: _deviceIP,
          deviceName: _deviceName,
          deviceType: _deviceType,
        ),
        data: data,
      ),
    );
  }

  void refreshDevices() {
    _devices.clear();
    _onDevicesChange?.call(_devices);
    _broadcastMessage(
      LanMsgEntity(
        type: 3,
        device: DeviceEntity(
          deviceIp: _deviceIP,
          deviceName: _deviceName,
          deviceType: _deviceType,
        ),
      ),
    );
  }
}
