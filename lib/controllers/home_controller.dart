import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/model/product/product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  List<Product> products = [];
  List<Product> retrievedProducts = []; // Store retrieved products

  List<Product> flashSaleProducts = [];
  List<Product> retrievedFlashSaleProducts = [];

  List<Product> productsForWomen = [];
  List<Product> retrievedProductsForWomen = [];

  List<Product> productsForMen = [];
  List<Product> retrievedProductsForMen = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
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
            product.numOfferPercent! >= 40;
      }).toList();
      flashSaleProducts.assignAll(retrievedFlashSaleProducts);

      // Products for women
      QuerySnapshot productForWomenSnapshot =
          await productCollection.where('gender', isEqualTo: 'Women').get();
      retrievedProductsForWomen = productForWomenSnapshot.docs
          .map((doc) =>
              Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      productsForWomen.assignAll(retrievedProductsForWomen);

      //Products for Men
      QuerySnapshot productForMenSnapshot =
          await productCollection.where('gender', isEqualTo: 'Men').get();
      retrievedProductsForMen = productForMenSnapshot.docs
          .map((doc) =>
              Product.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      productsForMen.assignAll(retrievedProductsForMen);

      Get.snackbar('Success', 'Products fetched Successfully',
          colorText: Colors.green);
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

  sortFilterByGender(String sortOption, List<String> selectedGender) {
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
}
