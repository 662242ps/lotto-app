// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String message;
  User user;

  LoginResponse({required this.message, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "user": user.toJson()};
}

class User {
  int userId;
  String email;
  String name;
  String role;
  String phone;
  DateTime birthday;
  String wallet;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
    required this.birthday,
    required this.wallet,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    email: json["email"],
    name: json["name"],
    role: json["role"],
    phone: json["phone"],
    birthday: DateTime.parse(json["birthday"]),
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "name": name,
    "role": role,
    "phone": phone,
    "birthday": birthday.toIso8601String(),
    "wallet": wallet,
  };
}
