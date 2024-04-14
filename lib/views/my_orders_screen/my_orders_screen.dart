import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widgets_common/bg_widget.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (ctrl) {
        return FutureBuilder(
          future: ctrl.getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _buildOrdersList(ctrl);
            }
          },
        );
      },
    );
  }

  Widget _buildOrdersList(UserController ctrl) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: orders.text.fontFamily(bold).white.make(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ctrl.userOrders.isNotEmpty
                ? ListView.builder(
                    itemCount: ctrl.userOrders.length,
                    itemBuilder: (context, index) {
                      var order = ctrl.userOrders[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.deepOrangeAccent, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ListTile(
                            title: Text(
                              order.productName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Rs. ${order.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () {},
                              child: order.state.capitalizeFirst.toString().text.fontFamily(bold).orange600.make()
                            ),
                            // Add onTap and trailing widgets if needed
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: noOrders.text.fontFamily(bold).black.make()),
          ),
        ),
      ),
    );
  }
}
