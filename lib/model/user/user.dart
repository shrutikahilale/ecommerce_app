// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

EcomUser userFromJson(String str) => EcomUser.fromJson(json.decode(str));

String userToJson(EcomUser data) => json.encode(data.toJson());

class EcomUser {
  String email;
  String name;

  EcomUser({
    required this.email,required this.name,
  });

  factory EcomUser.fromJson(Map<String, dynamic> json) => EcomUser(
    email: json["email"],
    name: json["mail"]
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
