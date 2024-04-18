import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import '../model/product/product.dart';
import '../model/user/user.dart';

class UserController extends GetxController {
  FirebaseFirestore userDb = FirebaseFirestore.instance;
  late Future<EcomUser?> user;
  late DocumentReference<Object?> currentUser;

  List<OrderModal> userOrders = [];
  List<Product> userProductWishlist = [];

  @override
  Future<void> onInit() async {
    CollectionReference users = userDb.collection('users');
    currentUser = users.doc(FirebaseAuth.instance.currentUser?.email);
    user = fetchUserDetails(); // Assigning Future<EcomUser?> to user
    super.onInit();
  }

  Future<EcomUser?> fetchUserDetails() async {
    try {
      var snapshot = await currentUser.get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        return EcomUser(email: data['email'], name: data['name']);
      } else {
        Get.snackbar('Error', 'User does not exist', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
    return null; // Return null if user doesn't exist or error occurs
  }

  getOrders() async {
    try {
      var snapshot = await currentUser.get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> listOrders = data['orders'];
        if (listOrders.isNotEmpty) {
          userOrders = listOrders.map((orderData) {
            return OrderModal(
                productName: orderData['productName'],
                price: orderData['price'],
                billingAddress: orderData['billingAddress'],
                rating: orderData['rating'],
                state: orderData['state']);
          }).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  addOrder(OrderModal order) async {
    try {
      userOrders.add(order);
      currentUser.update({
        "orders": FieldValue.arrayUnion([
          {
            'productName': order.productName,
            'price': order.price,
            'billingAddress': order.billingAddress,
            'rating': order.rating,
            'state': order.state,
          }
        ])
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  getWishlist() async {
    try {
      var snapshot = await currentUser.get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> wishlist = data['wishlist'];

        if (wishlist.isNotEmpty) {
          var products = await FirebaseFirestore.instance
              .collection('products')
              .where(FieldPath.documentId, whereIn: wishlist)
              .get();

          userProductWishlist = products.docs.map((product) {
            return Product(
                id: product['id'],
                name: product['name'],
                description: product['description'],
                category: product['category'],
                gender: product['gender'],
                image: product['image'],
                offer: product['offer'],
                offerPercent: product['offerPercent'],
                price: (product['price'] as num?)?.toDouble(),
                brand: product['brand'],
                review: (product['review'] as num?)?.toDouble(),
                numOfferPercent:
                    (product['numOfferPercent'] as num?)?.toDouble(),
                docId: product.id // doc id
                );
          }).toList();
        }
      }
    } catch (e) {
      Get.snackbar('Error hello', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (snapshot.exists) {
        // Extract the data from the snapshot
        Map<String, dynamic> product = snapshot.data() as Map<String, dynamic>;
        // Add the product to the user's wishlist
        userProductWishlist.add(Product(
            id: product['id'],
            name: product['name'],
            description: product['description'],
            category: product['category'],
            gender: product['gender'],
            image: product['image'],
            offer: product['offer'],
            offerPercent: product['offerPercent'],
            price: (product['price'] as num?)?.toDouble(),
            brand: product['brand'],
            review: (product['review'] as num?)?.toDouble(),
            numOfferPercent: (product['numOfferPercent'] as num?)?.toDouble(),
            docId: snapshot.id // doc id
            ));
        await currentUser.update({
          "wishlist": FieldValue.arrayUnion([productId])
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      userProductWishlist.removeWhere((product) => product.docId == productId);
      await currentUser.update({
        "wishlist": FieldValue.arrayRemove([productId])
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  bool isProductAddedToWishlist(String productId) {
    return userProductWishlist
            .indexWhere((product) => product.docId == productId) !=
        -1;
  }
}
