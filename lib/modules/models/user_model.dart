class UserModel {
  final String id;
  final String? userName;
  final String? fullName;
  final String email;
  final String? photoUrl;
  final String phoneNumber;
  final DateTime createAt;
  final DateTime updateAt;
  UserModel({
    required this.id,
    required this.userName,
    this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createAt,
    required this.updateAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? userName,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    DateTime? createAt,
    DateTime? updateAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, photoUrl: $photoUrl, createAt: $createAt, updateAt: $updateAt)';
  }
}
