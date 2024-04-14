// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json, String docID) => Product(
    id: json['id'] as String?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    category: json['category'] as String?,
    image: json['image'] as String?,
    offer: json['offer'] as bool?,
    offerPercent: json['offerPercent'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    brand: json['brand'] as String?,
    review: (json['review'] as num?)?.toDouble(),
    gender: json['gender'] as String?,
    numOfferPercent: (json['numOfferPercent'] as num?)?.toDouble(),
    docId: docID);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'image': instance.image,
      'price': instance.price,
      'brand': instance.brand,
      'offer': instance.offer,
      'offerPercent': instance.offerPercent,
      'review': instance.review,
      'numOfferPercent': instance.numOfferPercent,
      'gender': instance.gender,
    };
