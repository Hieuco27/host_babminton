class TM05Config {
  final String deviceId;
  final String macAddress;
  final String bluetoothName;
  final int stepAngle;
  final int gearRatio;
  final int rotationTime;
  final int type;
  final DateTime? configureAt;

  TM05Config({
    required this.deviceId,
    required this.macAddress,
    required this.bluetoothName,
    required this.stepAngle,
    required this.gearRatio,
    required this.rotationTime,
    required this.type,
    this.configureAt,
  });

  factory TM05Config.fromJson(Map<String, dynamic> json) {
    return TM05Config(
      deviceId: json['deviceId']?.toString() ?? '',
      macAddress: json['macAddress']?.toString() ?? '',
      bluetoothName: json['bluetoothName']?.toString() ?? 'Không tên',

      stepAngle: _toInt(json['stepAngle']) ?? 0,
      gearRatio: _toInt(json['gearRatio']) ?? 0,
      rotationTime: _toInt(json['rotationTime']) ?? 0,
      type: _toInt(json['type']) ?? 0,

      configureAt: DateTime.parse(json['configureAt'] ?? ''),
    );
  }

  // Hàm helper phụ trợ ép kiểu int an toàn
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'macAddress': macAddress,
      'bluetoothName': bluetoothName,
      'stepAngle': stepAngle.toString(),
      'gearRatio': gearRatio.toString(),
      'rotationTime': rotationTime.toString(),
      'type': type.toString(),
      'configureAt': configureAt?.toIso8601String(),
    };
  }

  TM05Config copyWith({
    String? deviceId,
    String? macAddress,
    String? bluetoothName,
    int? stepAngle,
    int? gearRatio,
    int? rotationTime,
    int? type,
    DateTime? configureAt,
  }) {
    return TM05Config(
      deviceId: deviceId ?? this.deviceId,
      macAddress: macAddress ?? this.macAddress,
      bluetoothName: bluetoothName ?? this.bluetoothName,
      stepAngle: stepAngle ?? this.stepAngle,
      gearRatio: gearRatio ?? this.gearRatio,
      rotationTime: rotationTime ?? this.rotationTime,
      type: type ?? this.type,
      configureAt: configureAt ?? this.configureAt,
    );
  }

  @override
  String toString() {
    return 'TM05Config{deviceId: $deviceId, macAddress: $macAddress, bluetoothName: $bluetoothName, stepAngle: $stepAngle, gearRatio: $gearRatio, rotationTime: $rotationTime, type: $type, configureAt: $configureAt}';
  }
}
