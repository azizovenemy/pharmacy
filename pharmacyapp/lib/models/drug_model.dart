import 'dart:convert';

DrugModel drugModelFromJson(String str) => DrugModel.fromJson(json.decode(str));

String drugModelToJson(DrugModel data) => json.encode(data.toJson());

class DrugModel {
  int id;
  String title;
  String description;
  int categoryId;
  String image;
  double price;
  double rating;

  DrugModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) => DrugModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        categoryId: json["drug_category_id"],
        image: json["image"],
        price: double.parse(json["price"]),
        rating: double.parse(json["rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "category_id": categoryId,
        "image": image,
        "price": price,
        "rating": rating,
      };
}
