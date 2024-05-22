import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:ecommerce_app/model/order/order.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/progress_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class ProductDescriptionPage extends StatefulWidget {
  const ProductDescriptionPage({super.key});

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    double rating = product.review ?? 0.0;
    double discountPrice = double.parse(
        (product.price! - product.numOfferPercent! * product.price! / 100)
            .toStringAsFixed(0));
    TextEditingController controller = TextEditingController();
    final homeController = Get.find<HomeController>();

    return GetBuilder<UserController>(
      builder: (userController) {
        return FutureBuilder(
            future: userController.getWishlist(),
            builder: (context, snapshot) {
              bool isProductAdded = userController
                  .isProductAddedToWishlist(product.docId.toString());
              return Scaffold(
                backgroundColor: whiteColor,
                appBar: AppBar(
                  title: const Text('Product Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  actions: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                    IconButton(
                      onPressed: () async {
                        if (isProductAdded) {
                          // Remove product id from the user's wishlist
                          await userController
                              .removeFromWishlist(product.docId.toString());
                          Get.snackbar(
                              'Success', 'Product removed from wishlist',
                              colorText: Colors.black,
                              backgroundColor: Colors.amber,
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          // Add product id to the user's wishlist
                          await userController
                              .addToWishlist(product.docId.toString());
                          Get.snackbar('Success', 'Product added to wishlist',
                              colorText: Colors.white,
                              backgroundColor: Colors.pink,
                              snackPosition: SnackPosition.BOTTOM);

                          isProductAdded = true;
                        }
                        setState(() {
                          isProductAdded = !isProductAdded;
                        });
                      },
                      icon: Icon(userController.isProductAddedToWishlist(
                              product.docId.toString())
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product.image ?? '',
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              10.heightBox,
                              //rating

                              IgnorePointer(
                                ignoring: true,
                                child: RatingBar.builder(
                                    initialRating: rating,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 25,
                                    itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: golden,
                                        ),
                                    onRatingUpdate: (rating) {}),
                              ),

                              const SizedBox(height: 20),
                              Text(
                                product.name ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                product.description ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                product.offer == true
                                    ? 'Discounted Price : Rs. $discountPrice'
                                    : 'Rs. ${product.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: controller,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Enter your Billing Address',
                                ),
                              ),

                              20.heightBox,
                              //products may like section
                              FutureBuilder(
                                  future:
                                      homeController.fetchRecommendedProducts(
                                    product.name!.split(' '),
                                    product.id.toString(),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CustomProgressIndicator();
                                    } else if (homeController
                                        .recommendedProducts.isEmpty) {
                                      return const SizedBox();
                                    } else if (homeController
                                        .recommendedProducts.isNotEmpty) {
                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: redColor),
                                        child: Column(
                                          children: [
                                            productsyoumaylike.text
                                                .fontFamily(bold)
                                                .size(16)
                                                .color(Colors.white)
                                                .make(),
                                            10.heightBox,
                                            SizedBox(
                                              height: 300,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: homeController
                                                    .recommendedProducts.length,
                                                itemBuilder: (context, index) {
                                                  return SizedBox(
                                                    width: 200,
                                                    child: ProductCard(
                                                      name: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .name ??
                                                          'no name',
                                                      imageUrl: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .image ??
                                                          'url',
                                                      price: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .price ??
                                                          0.00,
                                                      offerTag: (homeController
                                                                  .recommendedProducts[
                                                                      index]
                                                                  .offer ??
                                                              true)
                                                          ? homeController
                                                                  .recommendedProducts[
                                                                      index]
                                                                  .offerPercent ??
                                                              ' '
                                                          : ' ',
                                                      review: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .review ??
                                                          0.0,
                                                      numOfferPercent: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .numOfferPercent ??
                                                          0.0,
                                                      onTap: () {
                                                        Get.to(
                                                            () =>
                                                                const ProductDescriptionPage(),
                                                            arguments: {
                                                              'data': homeController
                                                                      .recommendedProducts[
                                                                  index]
                                                            });
                                                      },
                                                      hasOffer: homeController
                                                              .recommendedProducts[
                                                                  index]
                                                              .offer ??
                                                          false,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    'Buy Now',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (controller.text.isNotEmpty) {
                                      // Add order to the user's order list
                                      userController.addOrder(
                                        OrderModal(
                                          productName: product.name.toString(),
                                          price: product.price.toString(),
                                          billingAddress:
                                              controller.text.trim(),
                                          rating: product.review.toString(),
                                          state: 'ordered',
                                        ),
                                        product.docId.toString(),
                                      );

                                      Get.offAndToNamed('/my_orders');
                                      Get.snackbar(
                                        'Success',
                                        'Order added successfully!',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.green,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Please enter billing address'),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
