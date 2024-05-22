import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:ecommerce_app/model/product/product.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets_common/bg_widget.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final _userController = Get.find<UserController>();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: GetBuilder<HomeController>(builder: (ctrl) {
        List<Product> filteredProducts = ctrl.products.where((product) {
          if (_searchController.text.trim().isEmpty) return true;

          String productName = product.name.toString().toLowerCase();
          List<String> tokens = productName.split(' ');
          List<String> query = _searchController.text.toLowerCase().split(' ');
          List<String> keywords = [];

          // Check if every term in the query is present in the productName
          for (String term in query) {
            bool found = false;
            for (String token in tokens) {
              if (term == token) {
                keywords.add(token);
                found = true;
                break;
              }
            }
            if (!found) {
              // If any term from the query is not found in productName, return false
              return false;
            }
          }

          // If all terms are found, return true
          _userController.updateSearchHistory(keywords);
          return true;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                    onChanged: (value) {
                      ctrl.update(); // Rebuild UI on search text change
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: filteredProducts[index].name ?? 'no name',
                        imageUrl: filteredProducts[index].image ?? 'url',
                        price: filteredProducts[index].price ?? 0.00,
                        offerTag: (filteredProducts[index].offer ?? true)
                            ? filteredProducts[index].offerPercent ?? ' '
                            : ' ',
                        review: filteredProducts[index].review ?? 0.0,
                        numOfferPercent:
                            filteredProducts[index].numOfferPercent ?? 0.0,
                        onTap: () {
                          Get.to(const ProductDescriptionPage(),
                              arguments: {'data': filteredProducts[index]});
                        },
                        hasOffer: filteredProducts[index].offer ?? false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
