class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // 'rider' or 'driver'
  final bool isVerified; // Approved by admin
  final String vehicleType; // 'car' or 'motorcycle'
  final String vehicleModel; // e.g. 'Hyundai Accent'
  final double rating;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    this.vehicleType = '',
    this.vehicleModel = '',
    this.rating = 5.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'rating': rating,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'rider',
      isVerified: map['isVerified'] ?? false,
      vehicleType: map['vehicleType'] ?? '',
      vehicleModel: map['vehicleModel'] ?? '',
      rating: (map['rating'] ?? 5.0).toDouble(),
    );
  }
}
