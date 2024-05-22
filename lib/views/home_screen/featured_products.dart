import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widgets_common/product_card.dart';
import '../../widgets_common/product_description_page.dart';
import '../../widgets_common/progress_indicator.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return FutureBuilder(
            future: ctrl.fetchFeaturedProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomProgressIndicator();
              } else if (ctrl.featuredProducts.isEmpty) {
                return const SizedBox();
              } else if (ctrl.featuredProducts.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: const BoxDecoration(color: redColor),
                  child: Column(
                    children: [
                      recommendedForYou.text.white
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ctrl.featuredProducts.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 200,
                              child: ProductCard(
                                name: ctrl.featuredProducts[index].name ??
                                    'no name',
                                imageUrl:
                                    ctrl.featuredProducts[index].image ?? 'url',
                                price:
                                    ctrl.featuredProducts[index].price ?? 0.00,
                                offerTag:
                                    (ctrl.featuredProducts[index].offer ?? true)
                                        ? ctrl.featuredProducts[index]
                                                .offerPercent ??
                                            ' '
                                        : ' ',
                                review:
                                    ctrl.featuredProducts[index].review ?? 0.0,
                                numOfferPercent: ctrl.featuredProducts[index]
                                        .numOfferPercent ??
                                    0.0,
                                onTap: () {
                                  Get.to(() => const ProductDescriptionPage(),
                                      arguments: {
                                        'data': ctrl.featuredProducts[index]
                                      });
                                },
                                hasOffer:
                                    ctrl.featuredProducts[index].offer ?? false,
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
            });
      },
    );
  }
}
