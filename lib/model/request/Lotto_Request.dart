// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

Empty emptyFromJson(String str) => Empty.fromJson(json.decode(str));

String emptyToJson(Empty data) => json.encode(data.toJson());

class Empty {
    List<String> numbers;
    int price;
    String status;

    Empty({
        required this.numbers,
        required this.price,
        required this.status,
    });

    factory Empty.fromJson(Map<String, dynamic> json) => Empty(
        numbers: List<String>.from(json["numbers"].map((x) => x)),
        price: json["price"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "numbers": List<dynamic>.from(numbers.map((x) => x)),
        "price": price,
        "status": status,
    };
}
