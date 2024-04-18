import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/widgets_common/dropdown.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart' as MS;
import 'package:multi_dropdown/multiselect_dropdown.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  final int selectedIndex;
  CategoryDetails(
      {super.key, required this.title, required this.selectedIndex});

  final MultiSelectController<String> _brandsController =
      MultiSelectController();

  final MultiSelectController<String> _priceController =
      MultiSelectController();

  final MultiSelectController<String> _categoryController =
      MultiSelectController();

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

    return GetBuilder<HomeController>(
      builder: (ctrl) {
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
                        child: MS.MultiSelectDropDown<String>(
                          hint: 'Brands',
                          hintFontSize: 12,
                          clearIcon: const Icon(Icons.close),
                          controller: _brandsController,
                          onOptionSelected: (options) {
                            selectedBrands =
                                options.map((item) => item.label).toList();
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
                          options: const <ValueItem<String>>[
                            ValueItem(label: 'Catwalk', value: '1'),
                            ValueItem(label: 'ADIDAS', value: '2'),
                            ValueItem(label: 'Nike', value: '3'),
                            ValueItem(label: 'Puma', value: '4'),
                            ValueItem(label: 'Rocia', value: '5'),
                            ValueItem(label: 'Lotto', value: '6'),
                            ValueItem(label: 'Fila', value: '7'),
                            ValueItem(label: 'Carlton', value: '8'),
                            ValueItem(label: 'HM', value: '9'),
                            ValueItem(label: 'RedTape', value: '10'),
                            ValueItem(label: 'Reebok', value: '11'),
                            ValueItem(label: 'Lee', value: '12'),
                          ],
                          chipConfig: const ChipConfig(
                            backgroundColor: Colors.deepOrangeAccent,
                          ),
                          selectionType: SelectionType.multi,
                          dropdownHeight: 300,
                          optionTextStyle: const TextStyle(fontSize: 12),
                          selectedOptionIcon: const Icon(
                            Icons.check_circle,
                            color: Colors.deepOrange,
                            size: 18.0,
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
                          child: MS.MultiSelectDropDown(
                            hint: 'Price Range',
                            controller: _priceController,
                            options: const <ValueItem<String>>[
                              ValueItem(
                                  label: 'Below ₹500', value: 'below_500'),
                              ValueItem(
                                  label: '₹500 - ₹1000', value: '500_to_1000'),
                              ValueItem(
                                  label: '₹1000 - ₹2000',
                                  value: '1000_to_2000'),
                              ValueItem(
                                  label: '₹2000 - ₹5000',
                                  value: '2000_to_5000'),
                              ValueItem(
                                  label: 'Above ₹5000', value: 'above_5000'),
                            ],
                            onOptionSelected: (selectedItems) {
                              selectedPriceRange = selectedItems
                                  .map((item) => item.label)
                                  .toList();
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
                            chipConfig: const ChipConfig(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            selectionType: SelectionType.multi,
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 12),
                            selectedOptionIcon: const Icon(
                              Icons.check_circle,
                              color: Colors.deepOrange,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // Adjust vertical padding
                          child: MS.MultiSelectDropDown(
                            hint: 'Category',
                            controller: _categoryController,
                            options: const <ValueItem<String>>[
                              ValueItem(
                                  label: 'Casual Shoes', value: 'casual_shoes'),
                              ValueItem(label: 'Flats', value: 'flats'),
                              ValueItem(
                                  label: 'Flip Flops', value: 'flip_flops'),
                              ValueItem(
                                  label: 'Formal Shoes', value: 'formal_shoes'),
                              ValueItem(label: 'Heels', value: 'heels'),
                              ValueItem(label: 'Sandals', value: 'sandals'),
                              ValueItem(
                                  label: 'Sports Sandals',
                                  value: 'sports_sandals'),
                              ValueItem(
                                  label: 'Sports Shoes', value: 'sports_shoes'),
                            ],
                            onOptionSelected: (selectedItems) {
                              selectedCategories = selectedItems
                                  .map((item) => item.label)
                                  .toList();
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
                            chipConfig: const ChipConfig(
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            selectionType: SelectionType.multi,
                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 12),
                            selectedOptionIcon: const Icon(
                              Icons.check_circle,
                              color: Colors.deepOrange,
                              size: 18.0,
                            ),
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
                            name:
                                ctrl.productsForWomen[index].name ?? 'no name',
                            imageUrl:
                                ctrl.productsForWomen[index].image ?? 'url',
                            price: ctrl.productsForWomen[index].price ?? 0.00,
                            offerTag: (ctrl.productsForWomen[index].offer ??
                                    true)
                                ? ctrl.productsForWomen[index].offerPercent ??
                                    ' '
                                : ' ',
                            review: ctrl.productsForWomen[index].review ?? 0.0,
                            numOfferPercent:
                                ctrl.productsForWomen[index].numOfferPercent ??
                                    0.0,
                            onTap: () {
                              Get.to(const ProductDescriptionPage(),
                                  arguments: {
                                    'data': ctrl.productsForWomen[index]
                                  });
                            },
                            hasOffer:
                                ctrl.productsForWomen[index].offer ?? false,
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
                                ctrl.productsForMen[index].numOfferPercent ??
                                    0.0,
                            onTap: () {
                              Get.to(const ProductDescriptionPage(),
                                  arguments: {
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
      },
    );
  }
}
