import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../controllers/user_controller.dart';
import '../../widgets_common/bg_widget.dart';

class MyWishlistScreen extends StatelessWidget {
  const MyWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (ctrl) {
        return FutureBuilder(
          future: ctrl.getWishlist(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _buildOrdersList(ctrl);
            }
          },
        );
      },
    );
  }

  Widget _buildOrdersList(UserController ctrl) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: wishlist.text.fontFamily(bold).white.make(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ctrl.userProductWishlist.isNotEmpty
                ? ListView.builder(
                    itemCount: ctrl.userProductWishlist.length,
                    itemBuilder: (context, index) {
                      var order = ctrl.userProductWishlist[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.deepOrangeAccent, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ListTile(
                            title: Text(
                              order.name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Rs. ${order.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            trailing: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  ctrl.removeFromWishlist(ctrl
                                      .userProductWishlist[index].docId
                                      .toString());
                                  ctrl.update();
                                },
                                icon: const Icon(Icons.favorite_rounded),
                                color: Colors.deepOrange,
                              ),
                            ),
                            onTap: () {
                              Get.to(const ProductDescriptionPage(),
                                  arguments: {
                                    'data': ctrl.userProductWishlist[index]
                                  })?.then((_) {
                                // Refresh the wishlist after returning from ProductDescriptionPage
                                ctrl.update();
                              });
                            },
                            // Add onTap and trailing widgets if needed
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: noWishlistedProducts.text
                        .fontFamily(bold)
                        .black
                        .make()),
          ),
        ),
      ),
    );
  }
}
