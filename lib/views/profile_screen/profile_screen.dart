import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:ecommerce_app/model/user/user.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../consts/lists.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<EcomUser?>(
            future: Get.put(UserController()).user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                EcomUser? thisUser = snapshot.data;
                return Column(
                  children: [
                    Column(
                      children: [
                        // edit profile button
                        /*  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.edit, color: whiteColor))
                              .onTap(() {}),
                        ),*/

                        //user details section
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Image.asset(imgProfile2,
                                      width: 100, fit: BoxFit.cover)
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make(),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (thisUser != null)
                                      thisUser.name.text
                                          .fontFamily(semibold)
                                          .white
                                          .make(),
                                    if (thisUser != null)
                                      thisUser.email.text.white.make(),
                                  ],
                                ),
                              ),
                              10.widthBox,
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                    color: whiteColor,
                                  )),
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Get.offAndToNamed('/login_screen');
                                  },
                                  child: logout.text
                                      .fontFamily(semibold)
                                      .white
                                      .make())
                            ],
                          ),
                        ),

                        20.heightBox,
                        /*    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: "00",
                                title: "in your cart",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: "32",
                                title: "in your wishlist",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: "675",
                                title: "your orders",
                                width: context.screenWidth / 3.4),
                          ],
                        ),
                        // buttons section
                        40.heightBox,*/

                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Divider(color: lightGrey);
                          },
                          itemCount: profileButtonsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                    profileButtonsNamedNavigationScreenNames[
                                        index]);
                              },
                              child: ListTile(
                                leading: Image.asset(profileButtonsIcon[index],
                                    width: 22),
                                title: profileButtonsList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                              ),
                            );
                          },
                        )
                            .box
                            .white
                            .rounded
                            .margin(const EdgeInsets.all(12))
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make()
                            .box
                            .color(redColor)
                            .make(),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
