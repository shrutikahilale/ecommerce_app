import 'package:ecommerce_app/model/product/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      List<Product> filteredProducts = ctrl.products.where((product) {
        String productName = product.name.toString().toLowerCase();
        List<String> query = _searchController.text.toLowerCase().split(' ');
        return query.every((term) => productName.contains(term));
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
                    border: OutlineInputBorder(),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    });
  }
}
