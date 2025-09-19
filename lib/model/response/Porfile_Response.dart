// To parse this JSON data, do
//
//     final porfileResponse = porfileResponseFromJson(jsonString);

import 'dart:convert';

PorfileResponse porfileResponseFromJson(String str) =>
    PorfileResponse.fromJson(json.decode(str));

String porfileResponseToJson(PorfileResponse data) =>
    json.encode(data.toJson());

class PorfileResponse {
  String name;
  DateTime birthday;
  String email;
  String phone;

  PorfileResponse({
    required this.name,
    required this.birthday,
    required this.email,
    required this.phone,
  });

  factory PorfileResponse.fromJson(Map<String, dynamic> json) =>
      PorfileResponse(
        name: json["name"],
        birthday: DateTime.parse(json["birthday"]),
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "birthday": birthday.toIso8601String(),
    "email": email,
    "phone": phone,
  };
}
