import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/views/my_orders_screen/my_orders_screen.dart';
import 'package:ecommerce_app/views/my_wishlist_screen/my_wishlist_screen.dart';
import 'package:ecommerce_app/views/splash_screen/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDbVk86uP_dbDw5pfsDgEIDqxERX8MTsMQ",
        authDomain: "ecom-app-26cc3.firebaseapp.com",
        projectId: "ecom-app-26cc3",
        storageBucket: "ecom-app-26cc3.appspot.com",
        messagingSenderId: "773813254439",
        appId: "1:773813254439:web:4ef10340bffe471dc4d102",
        measurementId: "G-E1B0HEXLL4"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    // we are using getX so we have to change this materialApp into getMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce',
      theme: ThemeData(
          // This is the theme of our application.
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
              //to set app  bar icons
              iconTheme: IconThemeData(
                color: darkFontGrey,
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent),
          fontFamily: regular),
      initialRoute: '/',
      routes: {
        '/': (context) => const Wrapper(),
        '/login_screen': (context) => const LoginScreen(),
        '/register_now_screen': (context) => const SignupScreen(),
        '/home': (context) => const Home(),
        '/my_orders': (context) => const MyOrdersScreen(),
        '/my_wishlist': (context) => const MyWishlistScreen(),
      },
    );
  }
}
