import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/category_screen/topSeller_screen.dart';
import 'package:ecommerce_app/widgets_common/home_buttons.dart';
import 'package:ecommerce_app/widgets_common/dropdown.dart';
import 'package:ecommerce_app/widgets_common/multi_select_dropdown.dart';
import 'package:ecommerce_app/widgets_common/product_card.dart';
import 'package:ecommerce_app/widgets_common/product_description_page.dart';
import 'package:ecommerce_app/views/category_screen/flashSale_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String sortOption = '';
    List<String> selectedBrands = [];
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(12),
          color: lightGrey,
          width: context.screenWidth,
          height: context.screenHeight,
          child: SafeArea(
              child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 60,
                color: lightGrey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: searchanything,
                    hintStyle: TextStyle(color: textfieldGrey),
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
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),

                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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

                    /*

                    20.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          2,
                          (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 2.5,
                              icon: index == 0 ? icTodaysDeal : icFlashDeal,
                              title: index == 0 ? todayDeal : flashsale)),
                    ),
                      */
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
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),

                    /*
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButtons(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 3.5,
                                icon: index == 0
                                    ? icTopCategories
                                    : index == 1
                                        ? icBrands
                                        : icTopSeller,
                                title: index == 0
                                    ? topCategories
                                    : index == 1
                                        ? brand
                                        : topSellers,
                              )),
                    ),
                    */

                    // featured Categories
                    /*
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featuredButton(
                                  icon: featuredImages1[index],
                                  title: featuredTitles1[index]),
                              10.heightBox,
                              featuredButton(
                                  icon: featuredImages2[index],
                                  title: featuredTitles2[index]),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),

                    */

                    //featured product
                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
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
                                              width: 150, fit: BoxFit.cover),
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
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .roundedSM
                                          .padding(const EdgeInsets.all(8))
                                          .make()),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
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
                          child: MultiSelectDropDown(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            label: 'Select Brand',
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
                              ctrl.sortFilterProducts(
                                  sortOption, selectedBrands);
                            },
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
                              Get.to(const ProductDescriptionPage(),
                                  arguments: {'data': ctrl.products[index]});
                            },
                            hasOffer: ctrl.products[index].offer ?? false,
                          );
                        })
                  ],
                ),
              )),
            ],
          )),
        ),
      );
    });
  }
}
