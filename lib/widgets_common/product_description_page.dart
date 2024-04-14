import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:ecommerce_app/model/order/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';

class ProductDescriptionPage extends StatefulWidget {
  const ProductDescriptionPage({Key? key});

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    double rating = product.review ?? 0.0;
    TextEditingController controller = TextEditingController();

    return GetBuilder<UserController>(
      builder: (userController) {
        return FutureBuilder(
            future: userController.getWishlist(),
            builder: (context, snapshot) {
              bool isProductAdded = userController
                  .isProductAddedToWishlist(product.docId.toString());
              print('here in fututre builder');
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
                                'Rs. ${product.price}',
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
                              productsyoumaylike.text
                                  .fontFamily(bold)
                                  .size(16)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              // section copied from home screen featured products
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      6,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(imgP1,
                                                  width: 150,
                                                  fit: BoxFit.cover),
                                              10.heightBox,
                                              "Laptop 4GB/64GB"
                                                  .text
                                                  .fontFamily(semibold)
                                                  .color(darkFontGrey)
                                                  .make(),
                                              10.heightBox,
                                              "Rs. 50000"
                                                  .text
                                                  .color(redColor)
                                                  .fontFamily(bold)
                                                  .size(16)
                                                  .make()
                                            ],
                                          )
                                              .box
                                              .white
                                              .margin(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4))
                                              .roundedSM
                                              .padding(const EdgeInsets.all(8))
                                              .make()),
                                ),
                              ),

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
                                      userController.addOrder(OrderModal(
                                        productName: product.name.toString(),
                                        price: product.price.toString(),
                                        billingAddress: controller.text.trim(),
                                        rating: product.review.toString(),
                                        state: 'ordered',
                                      ));

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
