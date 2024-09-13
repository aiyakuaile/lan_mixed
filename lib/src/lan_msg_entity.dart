class LanMsgEntity {
  // -1: exit, 0: join, 1: online, 2: re-back 3:refresh
  final int type;
  final DeviceEntity? device;
  final String? data;

  LanMsgEntity({required this.type, this.data, this.device});

  factory LanMsgEntity.fromJson(Map<String, dynamic> json) {
    return LanMsgEntity(
      type: json['type'],
      device: DeviceEntity.fromJson(json['device']),
      data: json['data'],
    );
  }
  Map<String, dynamic> toJson() => {
        'type': type,
        'device': device?.toJson(),
        'data': data,
      };
}

class DeviceEntity {
  final String? deviceName;
  final String? deviceIp;
  final String? deviceType;
  const DeviceEntity({this.deviceName, this.deviceIp, this.deviceType});

  factory DeviceEntity.fromJson(Map<String, dynamic> json) {
    return DeviceEntity(
      deviceName: json['deviceName'],
      deviceIp: json['deviceIp'],
      deviceType: json['deviceType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'deviceName': deviceName,
        'deviceIp': deviceIp,
        'deviceType': deviceType,
      };
}
