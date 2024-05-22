import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/model/product/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../backend/api.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // late CollectionReference productCollection;
  late Query<Map<String, dynamic>> productCollection;

  List<Product> products = [];
  List<Product> retrievedProducts = []; // Store retrieved products

  List<Product> flashSaleProducts = [];
  List<Product> retrievedFlashSaleProducts = [];

  // ignore: non_constant_identifier_names
  List<Product> TopSellerProducts = [];
  List<Product> retrievedTopSellerProducts = [];

  List<Product> productsForWomen = [];
  List<Product> retrievedProductsForWomen = [];

  List<Product> productsForMen = [];
  List<Product> retrievedProductsForMen = [];

  List<Product> featuredProducts = [];
  List<Product> recommendedProducts = [];
  int limit = 50;

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products').limit(limit);
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      // All products
      QuerySnapshot productSnapshot = await productCollection.get();
      retrievedProducts = productSnapshot.docs
          .map((doc) =>
              Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      products.assignAll(retrievedProducts);

      // Flash Sale products
      retrievedFlashSaleProducts = retrievedProducts.where((product) {
        return product.numOfferPercent != null &&
            product.numOfferPercent! >= 20;
      }).toList();
      flashSaleProducts.assignAll(retrievedFlashSaleProducts);

      //Top Seller products
      retrievedTopSellerProducts = retrievedProducts.where((product) {
        return (product.order != null);
      }).toList();
      retrievedTopSellerProducts.sort((a, b) => b.order!.compareTo(a.order!));
      TopSellerProducts.assignAll(retrievedTopSellerProducts);

      // Products for women
      retrievedProductsForWomen = retrievedProducts
          .where((product) => product.gender == 'Women')
          .toList();
      productsForWomen.assignAll(retrievedProductsForWomen);

      // Products for men
      retrievedProductsForMen = retrievedProducts
          .where((product) => product.gender == 'Men')
          .toList();
      productsForMen.assignAll(retrievedProductsForMen);

      Get.snackbar('Success', 'Products fetched Successfully',
          colorText: Colors.green);

      print('products ${products.length}');
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
  }

  sortFilterProducts(String sortOption, List<String> selectedBrands) {
    products.assignAll(retrievedProducts);

    if (sortOption == 'price_asc') {
      products.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOption == 'price_desc') {
      products.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sortOption == 'rating_desc') {
      products.sort((a, b) => (b.review ?? 0).compareTo(a.review ?? 0));
    }

    if (selectedBrands.isNotEmpty) {
      // Filter products based on selected brands
      List<Product> filteredByBrands = products
          .where((product) => selectedBrands.contains(product.brand))
          .toList();
      products.assignAll(filteredByBrands);
    }
    update();
  }

  sortFilterByGenderFlashSale(String sortOption, List<String> selectedGender) {
    flashSaleProducts.assignAll(retrievedFlashSaleProducts);

    if (sortOption == 'price_asc') {
      flashSaleProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOption == 'price_desc') {
      flashSaleProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sortOption == 'rating_desc') {
      flashSaleProducts
          .sort((a, b) => (b.review ?? 0).compareTo(a.review ?? 0));
    }

    if (selectedGender.isNotEmpty) {
      // Filter products based on selected brands
      List<Product> filterByGender = retrievedFlashSaleProducts
          .where((product) => selectedGender.contains(product.gender))
          .toList();
      flashSaleProducts.assignAll(filterByGender);
    }

    update();
  }

  sortFilterByGenderTopSeller(String sortOption, List<String> selectedGender) {
    TopSellerProducts.assignAll(retrievedTopSellerProducts);

    if (sortOption == 'price_asc') {
      TopSellerProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOption == 'price_desc') {
      TopSellerProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sortOption == 'rating_desc') {
      TopSellerProducts.sort(
          (a, b) => (b.review ?? 0).compareTo(a.review ?? 0));
    }

    if (selectedGender.isNotEmpty) {
      // Filter products based on selected brands
      List<Product> filterByGender = retrievedTopSellerProducts
          .where((product) => selectedGender.contains(product.gender))
          .toList();
      TopSellerProducts.assignAll(filterByGender);
    }

    update();
  }

  sortAndFilterAllForWomen(String sortOption, List<String> selectedBrands,
      List<String> selectedRanges, List<String> selectedCategories) {
    productsForWomen.assignAll(retrievedProductsForWomen);
    //sort
    if (sortOption == 'price_asc') {
      productsForWomen.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOption == 'price_desc') {
      productsForWomen.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sortOption == 'rating_desc') {
      productsForWomen.sort((a, b) => (b.review ?? 0).compareTo(a.review ?? 0));
    }
    //filter brands
    if (selectedBrands.isNotEmpty) {
      List<Product> filteredByBrands = productsForWomen
          .where((product) => selectedBrands.contains(product.brand))
          .toList();
      productsForWomen.assignAll(filteredByBrands);
    }
    //filter by price
    if (selectedRanges.isNotEmpty) {
      List<Product> filteredProducts = [];
      for (String range in selectedRanges) {
        if (range == 'Below ₹500') {
          filteredProducts.addAll(
              productsForWomen.where((product) => (product.price ?? 0) < 500));
        } else if (range == '₹500 - ₹1000') {
          filteredProducts.addAll(productsForWomen.where((product) =>
              (product.price ?? 0) >= 500 && (product.price ?? 0) < 1000));
        } else if (range == '₹1000 - ₹2000') {
          filteredProducts.addAll(productsForWomen.where((product) =>
              (product.price ?? 0) >= 1000 && (product.price ?? 0) < 2000));
        } else if (range == '₹2000 - ₹5000') {
          filteredProducts.addAll(productsForWomen.where((product) =>
              (product.price ?? 0) >= 2000 && (product.price ?? 0) < 5000));
        } else if (range == 'Above ₹5000') {
          filteredProducts.addAll(productsForWomen
              .where((product) => (product.price ?? 0) >= 5000));
        } else {
          filteredProducts.addAll(productsForWomen);
        }
      }
      filteredProducts = filteredProducts.toSet().toList();
      productsForWomen.assignAll(filteredProducts);
    }
    //filter by category
    if (selectedCategories.isNotEmpty) {
      List<Product> filteredProducts = [];
      for (String category in selectedCategories) {
        filteredProducts.addAll(
            productsForWomen.where((product) => product.category == category));
      }
      filteredProducts = filteredProducts.toSet().toList();
      productsForWomen.assignAll(filteredProducts);
    }
    update();
  }

  sortAndFilterAllForMen(String sortOption, List<String> selectedBrands,
      List<String> selectedRanges, List<String> selectedCategories) {
    productsForMen.assignAll(retrievedProductsForMen);
    //sort
    if (sortOption == 'price_asc') {
      productsForMen.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOption == 'price_desc') {
      productsForMen.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    } else if (sortOption == 'rating_desc') {
      productsForMen.sort((a, b) => (b.review ?? 0).compareTo(a.review ?? 0));
    }
    //filter brands
    if (selectedBrands.isNotEmpty) {
      List<Product> filteredByBrands = productsForMen
          .where((product) => selectedBrands.contains(product.brand))
          .toList();
      productsForMen.assignAll(filteredByBrands);
    }
    //filter by price
    if (selectedRanges.isNotEmpty) {
      List<Product> filteredProducts = [];
      for (String range in selectedRanges) {
        if (range == 'Below ₹500') {
          filteredProducts.addAll(
              productsForMen.where((product) => (product.price ?? 0) < 500));
        } else if (range == '₹500 - ₹1000') {
          filteredProducts.addAll(productsForMen.where((product) =>
              (product.price ?? 0) >= 500 && (product.price ?? 0) < 1000));
        } else if (range == '₹1000 - ₹2000') {
          filteredProducts.addAll(productsForMen.where((product) =>
              (product.price ?? 0) >= 1000 && (product.price ?? 0) < 2000));
        } else if (range == '₹2000 - ₹5000') {
          filteredProducts.addAll(productsForMen.where((product) =>
              (product.price ?? 0) >= 2000 && (product.price ?? 0) < 5000));
        } else if (range == 'Above ₹5000') {
          filteredProducts.addAll(
              productsForMen.where((product) => (product.price ?? 0) >= 5000));
        } else {
          filteredProducts.addAll(productsForMen);
        }
      }
      filteredProducts = filteredProducts.toSet().toList();
      productsForMen.assignAll(filteredProducts);
    }
    //filter by category
    if (selectedCategories.isNotEmpty) {
      List<Product> filteredProducts = [];
      for (String category in selectedCategories) {
        filteredProducts.addAll(
            productsForMen.where((product) => product.category == category));
      }
      filteredProducts = filteredProducts.toSet().toList();
      productsForMen.assignAll(filteredProducts);
    }
    update();
  }

  Future<List<Product>> fetchRecommendedProducts(
      List<String> query, String productId) async {
    try {
      List<dynamic> productsIds = await getRecommendations(query);
      List<String> productIdsStrings =
          productsIds.map((id) => id.toString()).toList();

      recommendedProducts = retrievedProducts.where((product) {
        return productIdsStrings.contains(product.id.toString()) &&
            productId != product.id.toString();
      }).toList();
    } catch (e) {
      print('error: $e');
    }
    List<Product> res = [];
    return res;
  }

  fetchFeaturedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await firestore.collection('users').doc(user.email).get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> search_history = data['search_history'];

        if (search_history.isEmpty) {
          featuredProducts = [];
        } else {
          List<String> searchHistory =
              search_history.map((keyword) => keyword.toString()).toList();

          List productIds = await getFeaturedProducts(searchHistory);
          List<String> productIdsStrings =
              productIds.map((id) => id.toString()).toList();

          featuredProducts = retrievedProducts.where((product) {
            return productIdsStrings.contains(product.id.toString());
          }).toList();

          print(featuredProducts.map((e) => e.name));
        }
      }
    }
  }
}
