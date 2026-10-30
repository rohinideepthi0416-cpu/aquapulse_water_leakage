class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String passwordHash;
  final String salt;
  final String role; // 'citizen' or 'admin'
  final String address;
  final String createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.salt,
    this.role = 'citizen',
    required this.address,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email.toLowerCase().trim(),
      'phone': phone.trim(),
      'password_hash': passwordHash,
      'salt': salt,
      'role': role,
      'address': address.trim(),
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      passwordHash: map['password_hash'] as String? ?? '',
      salt: map['salt'] as String? ?? '',
      role: map['role'] as String? ?? 'citizen',
      address: map['address'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? passwordHash,
    String? salt,
    String? role,
    String? address,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      role: role ?? this.role,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
