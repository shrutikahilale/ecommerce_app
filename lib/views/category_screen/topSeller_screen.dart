import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';

class TopSellerScreen extends StatelessWidget {
  const TopSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: topSellers.text.fontFamily(bold).white.make(),
        ),
        body: const SingleChildScrollView(),
      ),
    );
  }
}
