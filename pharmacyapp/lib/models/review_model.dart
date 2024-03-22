import 'dart:convert';

import 'package:pharmacyapp/models/user_model.dart';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  int id;
  int userId;
  int drugId;
  String text;
  int rating;
  UserModel user;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.drugId,
    required this.text,
    required this.rating,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        userId: json["user_id"],
        drugId: json["drug_id"],
        text: json["text"],
        rating: json["rating"],
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "drug_id": drugId,
        "text": text,
        "rating": rating,
        "user": user.toJson(),
      };
}
