import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/multi_select_dropdown.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:get/get.dart';

import '../../widgets_common/dropdown.dart';

class TopSellerScreen extends StatelessWidget {
  const TopSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dropDownDecoration = BoxDecoration(
      border: Border.all(color: Colors.white),
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    );
    String sortOption = '';
    List<String> selectedGender = [];

    return GetBuilder<HomeController>(builder: (ctrl) {
      return bgWidget(
        child: Scaffold(
          appBar: AppBar(
            title: topSellers.text.fontFamily(bold).white.make(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropDownBtn(
                            items: const [
                              'Rs. Low to High',
                              'Rs. High to Low',
                              'Rating'
                            ],
                            selectedItemText: 'Sort',
                            onSelect: (selected) {
                              if (selected == 'Rs. Low to High') {
                                sortOption = 'price_asc';
                              } else if (selected == 'Rs. High to Low') {
                                sortOption = 'price_desc';
                              } else if (selected == 'Rating') {
                                sortOption = 'rating_desc';
                              }
                              ctrl.sortFilterByGenderTopSeller(
                                  sortOption, selectedGender);
                            },
                            decoration: dropDownDecoration,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MultiSelectDropDown(
                            label: 'Gender',
                            decoration: dropDownDecoration,
                            items: const ['Women', 'Men'],
                            onSelectionChanged: (selectedItems) {
                              selectedGender = selectedItems.cast<String>();
                              ctrl.sortFilterByGenderTopSeller(
                                  sortOption, selectedGender);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ctrl.TopSellerProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 300,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.TopSellerProducts[index].name ?? 'no name',
                        imageUrl: ctrl.TopSellerProducts[index].image ?? 'url',
                        price: ctrl.TopSellerProducts[index].price ?? 0.00,
                        offerTag: (ctrl.TopSellerProducts[index].offer ?? true)
                            ? ctrl.TopSellerProducts[index].offerPercent ?? ' '
                            : ' ',
                        review: ctrl.TopSellerProducts[index].review ?? 0.0,
                        numOfferPercent:
                            ctrl.TopSellerProducts[index].numOfferPercent ??
                                0.0,
                        onTap: () {
                          Get.to(const ProductDescriptionPage(), arguments: {
                            'data': ctrl.TopSellerProducts[index]
                          });
                        },
                        hasOffer: ctrl.TopSellerProducts[index].offer ?? false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
