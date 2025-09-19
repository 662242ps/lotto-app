// To parse this JSON data, do
//
//     final lottoResponse = lottoResponseFromJson(jsonString);

import 'dart:convert';

List<LottoResponse> lottoResponseFromJson(String str) =>
    List<LottoResponse>.from(
      json.decode(str).map((x) => LottoResponse.fromJson(x)),
    );

String lottoResponseToJson(List<LottoResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LottoResponse {
  int lottoId;
  int rewardId;
  String number;
  String price;
  String status;

  LottoResponse({
    required this.lottoId,
    required this.rewardId,
    required this.number,
    required this.price,
    required this.status,
  });

  factory LottoResponse.fromJson(Map<String, dynamic> json) => LottoResponse(
    lottoId: json["lotto_id"],
    rewardId: json["reward_id"],
    number: json["number"],
    price: json["price"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "lotto_id": lottoId,
    "reward_id": rewardId,
    "number": number,
    "price": price,
    "status": status,
  };
}
