import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String firstName;
  String lastName;
  String login;
  String password;
  int personalDiscount;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.password,
    required this.personalDiscount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        login: json["login"],
        password: json["password"],
        personalDiscount: json["personal_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "login": login,
        "password": password,
        "personal_discount": personalDiscount,
      };
}
