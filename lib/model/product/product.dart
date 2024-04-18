import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "category")
  String? category;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "brand")
  String? brand;

  @JsonKey(name: "offer")
  bool? offer;

  @JsonKey(name: "offerPercent")
  String? offerPercent;

  @JsonKey(name: "review")
  double? review;

  @JsonKey(name: "numOfferPercent")
  double? numOfferPercent;

  @JsonKey(name: "docId")
  String? docId;

  @JsonKey(name: "order")
  double? order;

  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.gender,
    this.image,
    this.offer,
    this.offerPercent,
    this.price,
    this.brand,
    this.review,
    this.numOfferPercent,
    this.docId,
    this.order,
  });

  factory Product.fromJson(Map<String, dynamic> json, String docID) =>
      _$ProductFromJson(json, docID);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
