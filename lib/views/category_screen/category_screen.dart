import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/category_screen/category_details.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> catImages = [
      'assets/images/womenFootware.jpg',
      'assets/images/MenFootware.jpg',
    ];

    List<String> catText = [
      'Women Footware',
      'Men  Footware',
    ];

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => CategoryDetails(
                          title: catText[index], selectedIndex: index));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              catImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          catText[index]
                              .text
                              .color(Colors.black)
                              .fontWeight(FontWeight.bold)
                              .size(16)
                              .align(TextAlign.center)
                              .make(),
                        ],
                      ),
                    ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
