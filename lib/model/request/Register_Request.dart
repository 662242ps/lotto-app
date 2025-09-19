// To parse this JSON data, do
//
//     final registerRequest = registerRequestFromJson(jsonString);

import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String email;
  String password;
  String name;
  String role;
  String phone;
  DateTime birthday;
  int wallet;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.phone,
    required this.birthday,
    required this.wallet,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        role: json["role"],
        phone: json["phone"],
        birthday: DateTime.parse(json["birthday"]),
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "name": name,
    "role": role,
    "phone": phone,
    "birthday":
        "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "wallet": wallet,
  };
}
