import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/widgets_common/dropdown.dart';
import 'package:ecommerce_app/widgets_common/multi_select_dropdown.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  final int selectedIndex;
  const CategoryDetails(
      {super.key, required this.title, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final dropDownDecoration = BoxDecoration(
      border: Border.all(color: Colors.white),
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    );

    String sortOption = '';
    List<String> selectedBrands = [];
    List<String> selectedPriceRange = [];
    List<String> selectedCategories = [];

    return GetBuilder<HomeController>(builder: (ctrl) {
      return bgWidget(
        child: Scaffold(
          appBar: AppBar(
            title: title!.text.fontFamily(bold).white.make(),
          ),
          body: Padding(
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
                            if (selectedIndex == 0) {
                              ctrl.sortAndFilterAllForWomen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            } else {
                              ctrl.sortAndFilterAllForMen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            }
                          },
                          decoration: dropDownDecoration,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MultiSelectDropDown(
                          label: 'Brands',
                          decoration: dropDownDecoration,
                          items: const [
                            'Catwalk',
                            'ADIDAS',
                            'Nike',
                            'Puma',
                            'Rocia',
                            'Lotto',
                            'Fila',
                            'Carlton',
                            'HM',
                            'RedTape',
                            'Reebok',
                            'Lee'
                          ],
                          onSelectionChanged: (selectedItems) {
                            selectedBrands = selectedItems.cast<String>();
                            if (selectedIndex == 0) {
                              ctrl.sortAndFilterAllForWomen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            } else {
                              ctrl.sortAndFilterAllForMen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Adjust vertical padding
                        child: MultiSelectDropDown(
                          label: 'Price Range',
                          decoration: dropDownDecoration,
                          items: const [
                            'Below ₹500',
                            '₹500 - ₹1000',
                            '₹1000 - ₹2000',
                            '₹2000 - ₹5000',
                            'Above ₹5000'
                          ],
                          onSelectionChanged: (selectedItems) {
                            selectedPriceRange = selectedItems.cast<String>();
                            if (selectedIndex == 0) {
                              ctrl.sortAndFilterAllForWomen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            } else {
                              ctrl.sortAndFilterAllForMen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            }
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Adjust vertical padding
                        child: MultiSelectDropDown(
                          label: 'Category',
                          decoration: dropDownDecoration,
                          items: const [
                            'Casual Shoes',
                            'Flats',
                            'Flip Flops',
                            'Formal Shoes',
                            'Heels',
                            'Sandals',
                            'Sports Sandals',
                            'Sports Shoes'
                          ],
                          onSelectionChanged: (selectedItems) {
                            selectedCategories = selectedItems.cast<String>();
                            if (selectedIndex == 0) {
                              ctrl.sortAndFilterAllForWomen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            } else {
                              ctrl.sortAndFilterAllForMen(
                                  sortOption,
                                  selectedBrands,
                                  selectedPriceRange,
                                  selectedCategories);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: selectedIndex == 0
                        ? ctrl.productsForWomen.length
                        : ctrl.productsForMen.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (selectedIndex == 0) {
                        return ProductCard(
                          name: ctrl.productsForWomen[index].name ?? 'no name',
                          imageUrl: ctrl.productsForWomen[index].image ?? 'url',
                          price: ctrl.productsForWomen[index].price ?? 0.00,
                          offerTag: (ctrl.productsForWomen[index].offer ?? true)
                              ? ctrl.productsForWomen[index].offerPercent ?? ' '
                              : ' ',
                          review: ctrl.productsForWomen[index].review ?? 0.0,
                          numOfferPercent:
                              ctrl.productsForWomen[index].numOfferPercent ??
                                  0.0,
                          onTap: () {
                            Get.to(const ProductDescriptionPage(), arguments: {
                              'data': ctrl.productsForWomen[index]
                            });
                          },
                          hasOffer: ctrl.productsForWomen[index].offer ?? false,
                        );
                      } else {
                        return ProductCard(
                          name: ctrl.productsForMen[index].name ?? 'no name',
                          imageUrl: ctrl.productsForMen[index].image ?? 'url',
                          price: ctrl.productsForMen[index].price ?? 0.00,
                          offerTag: (ctrl.productsForMen[index].offer ?? true)
                              ? ctrl.productsForMen[index].offerPercent ?? ' '
                              : ' ',
                          review: ctrl.productsForMen[index].review ?? 0.0,
                          numOfferPercent:
                              ctrl.productsForMen[index].numOfferPercent ?? 0.0,
                          onTap: () {
                            Get.to(const ProductDescriptionPage(), arguments: {
                              'data': ctrl.productsForMen[index]
                            });
                          },
                          hasOffer: ctrl.productsForMen[index].offer ?? false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
