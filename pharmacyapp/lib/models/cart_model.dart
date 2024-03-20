import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  int id;
  int userId;
  int drugId;
  int quantity;

  CartModel({
    required this.id,
    required this.userId,
    required this.drugId,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        userId: json["user_id"],
        drugId: json["drug_id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "drug_id": drugId,
        "quantity": quantity,
      };
}
