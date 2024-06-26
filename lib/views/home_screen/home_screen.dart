import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/category_screen/flashSale_screen.dart';
import 'package:ecommerce_app/views/category_screen/topSeller_screen.dart';
import 'package:ecommerce_app/views/home_screen/search_page.dart';
import 'package:ecommerce_app/widgets_common/dropdown.dart';
import 'package:ecommerce_app/widgets_common/home_buttons.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart' as MS;
import 'package:multi_dropdown/multiselect_dropdown.dart';

import 'featured_products.dart';

class HomeScreen extends StatelessWidget {
  final MultiSelectController<String> _controller = MultiSelectController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String sortOption = '';
    List<String> selectedBrands = [];
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(12),
            color: lightGrey,
            width: context.screenWidth,
            height: context.screenHeight,
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SearchPage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      color: whiteColor,
                      child: const Text(
                        searchanything,
                        style: TextStyle(color: textfieldGrey),
                      ),
                    ),
                  ),
                  10.heightBox,
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          //swiper brand
                          VxSwiper.builder(
                              aspectRatio: 16 / 9,
                              autoPlay: true,
                              height: 150,
                              enlargeCenterPage: true,
                              itemCount: slidersList.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  slidersList[index],
                                  fit: BoxFit.fitWidth,
                                )
                                    .box
                                    .rounded
                                    .clip(Clip.antiAlias)
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 8))
                                    .make();
                              }),

                          20.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const FlashSaleScreen()),
                                      );
                                    },
                                    child: homeButtons(
                                      height: context.screenHeight * 0.15,
                                      width: context.screenWidth / 2.5,
                                      icon: icFlashDeal,
                                      title: flashsale,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TopSellerScreen()),
                                      );
                                    },
                                    child: homeButtons(
                                      height: context.screenHeight * 0.15,
                                      width: context.screenWidth / 2.5,
                                      icon: icTopSeller,
                                      title: topSellers,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //2nd swiper
                          20.heightBox,
                          VxSwiper.builder(
                              aspectRatio: 16 / 9,
                              autoPlay: true,
                              height: 150,
                              enlargeCenterPage: true,
                              itemCount: secondSlidersList.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  secondSlidersList[index],
                                  fit: BoxFit.fitWidth,
                                )
                                    .box
                                    .rounded
                                    .clip(Clip.antiAlias)
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 8))
                                    .make();
                              }),

                          //featured product
                          20.heightBox,
                          const FeaturedProducts(),

                          //Third Swiper
                          20.heightBox,
                          VxSwiper.builder(
                              aspectRatio: 16 / 9,
                              autoPlay: true,
                              height: 150,
                              enlargeCenterPage: true,
                              itemCount: secondSlidersList.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  secondSlidersList[index],
                                  fit: BoxFit.fitWidth,
                                )
                                    .box
                                    .rounded
                                    .clip(Clip.antiAlias)
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 8))
                                    .make();
                              }),

                          const SizedBox(height: 20),

                          // Inserted dropdown here

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
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
                                    ctrl.sortFilterProducts(
                                        sortOption, selectedBrands);
                                  },
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: MS.MultiSelectDropDown<String>(
                                  hint: 'Brands',
                                  hintFontSize: 12,
                                  clearIcon: const Icon(Icons.close),
                                  controller: _controller,
                                  onOptionSelected: (options) {
                                    selectedBrands = options
                                        .map((item) => item.label)
                                        .toList();
                                    ctrl.sortFilterProducts(
                                        sortOption, selectedBrands);
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
                                  optionTextStyle:
                                      const TextStyle(fontSize: 12),
                                  selectedOptionIcon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.deepOrange,
                                    size: 18.0,
                                  ),
                                ),
                              )
                            ],
                          ),

                          //all products section

                          20.heightBox,

                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ctrl.products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    mainAxisExtent: 300),
                            itemBuilder: (context, index) {
                              return ProductCard(
                                name: ctrl.products[index].name ?? 'no name',
                                imageUrl: ctrl.products[index].image ?? 'url',
                                price: ctrl.products[index].price ?? 0.00,
                                offerTag: (ctrl.products[index].offer ?? true)
                                    ? ctrl.products[index].offerPercent ?? ' '
                                    : ' ',
                                review: ctrl.products[index].review ?? 0.0,
                                numOfferPercent:
                                    ctrl.products[index].numOfferPercent ?? 0.0,
                                onTap: () {
                                  Get.to(() => const ProductDescriptionPage(),
                                      arguments: {
                                        'data': ctrl.products[index]
                                      });
                                },
                                hasOffer: ctrl.products[index].offer ?? false,
                              );
                            },
                          )
                        ],
                      ),
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
