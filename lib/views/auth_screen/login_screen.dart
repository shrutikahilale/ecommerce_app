import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/widgets_common/applogo_widget.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/custom_textfield.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the Form widget

  @override
  void dispose() {
    // Dispose controllers when they are no longer needed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = '';
  String _password = '';

  String? _validateEmail(String? value) {
    if (GetUtils.isEmail(value!)) {
      return null; // Valid email format
    } else {
      return 'Enter a valid email address';
    }
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8 || value!.length > 12) {
      return 'Password must be between 8 and 12 characters';
    } else if (!GetUtils.hasMatch(value, r'[a-zA-Z]') ||
        !GetUtils.hasMatch(value, r'[0-9]')) {
      return 'Password must contain both letters and numbers';
    } else {
      return null; // Valid password
    }
  }

  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.trim(), password: _password.trim());
    } on FirebaseAuthException catch (e) {
      String errorCode = e.code;
      if (errorCode == 'invalid-email') {
        // handle
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please re-check the email id entered'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (errorCode == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please re-check the email/password entered'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
                15.heightBox,
                Column(
                  children: [
                    CustomTextField(
                      hint: emailHint,
                      title: email,
                      controller: _emailController,
                      onChanged: (email) {
                        setState(() {
                          _email = email;
                        });
                      },
                      validator: _validateEmail,
                    ),
                    CustomTextField(
                      hint: passwordHint,
                      title: password,
                      controller: _passwordController,
                      onChanged: (password) {
                        setState(() {
                          _password = password;
                        });
                      },
                      validator: _validatePassword,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {}, child: forgetPass.text.make())),
                    5.heightBox,
                    ourButton(
                      color: redColor,
                      title: login,
                      textColor: whiteColor,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          // // Validation passed, proceed with login
                          // Get.to(() => Home());
                          signIn();
                        }
                      },
                    ).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    ourButton(
                        color: lightgolden,
                        title: signup,
                        textColor: redColor,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        }).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 30,
                                ),
                              ))),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
