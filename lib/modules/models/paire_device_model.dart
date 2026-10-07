class PairedDeviceModel {
  final String id; // MAC Address
  final String name; // Tên firmware gốc
  final String? customName; // Tên do user đặt
  final DateTime? lastConnectedAt;
  final String? typeDevices;

  const PairedDeviceModel({
    required this.id,
    required this.name,
    this.customName,
    this.lastConnectedAt,
    this.typeDevices,
  });

  /// Tên hiển thị lấy theo tên hiện tại của thiết bị/firmware.
  String get displayName => name;

  PairedDeviceModel copyWith({
    String? id,
    String? name,
    String? customName,
    String? typeDevices,
    DateTime? lastConnectedAt,
    bool clearCustomName = false,
  }) {
    return PairedDeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      customName: clearCustomName ? null : (customName ?? this.customName),
      typeDevices: typeDevices ?? this.typeDevices,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
    );
  }

  /// Chuyển từ JSON string (lấy từ SharedPreferences)
  factory PairedDeviceModel.fromJson(Map<String, dynamic> json) {
    return PairedDeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      customName: json['customName'] as String?,
      typeDevices: json['typeDevices']?.toString(),
      lastConnectedAt: json['lastConnectedAt'] != null
          ? DateTime.tryParse(json['lastConnectedAt'] as String)
          : null,
    );
  }

  /// Chuyển thành JSON để lưu vào SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (customName != null) 'customName': customName,
    'typeDevices': typeDevices,
    if (lastConnectedAt != null)
      'lastConnectedAt': lastConnectedAt!.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is PairedDeviceModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
