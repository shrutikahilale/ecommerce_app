import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widgets_common/applogo_widget.dart';
import 'package:ecommerce_app/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/widgets_common/custom_textfield.dart';
import 'package:ecommerce_app/widgets_common/our_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../splash_screen/wrapper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the Form widget
  bool? isCheck = false;
  final db = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reTypePasswordController =
      TextEditingController();

  String _name = '';
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
    if (value!.length < 8 || value.length > 12) {
      return 'Password must be between 8 and 12 characters';
    } else if (!GetUtils.hasMatch(value, r'[a-zA-Z]') ||
        !GetUtils.hasMatch(value, r'[0-9]')) {
      return 'Password must contain both letters and numbers';
    } else {
      return null; // Valid password
    }
  }

  String? validateName(String? value) {
    // Check if the name is empty
    if (value!.isEmpty) {
      return 'Name cannot be blank';
    }
    value = value.trim();

    // Check if the name contains numbers
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Name cannot contain numbers';
    }

    // Check if the name contains at least one word
    if (value.split(' ').isEmpty) {
      return 'Name must contain at least one word';
    }

    // Check if the name contains at most three words
    if (value.split(' ').length > 3) {
      return 'Name cannot contain more than three words';
    }

    // Check if the entire name exceeds 25 characters
    if (value.length > 25) {
      return 'Name cannot exceed 25 characters';
    }

    // If all checks pass, return null indicating a valid name
    return null;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate() ||
        _passwordController.text != _reTypePasswordController.text) {
      // Show toast message
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    // Check if all fields are valid
    else if (_formKey.currentState!.validate()) {
      registerNow();
    }
  }

  registerNow() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.trim(), password: _password.trim());
      // add user to DB
      addUser();

      Get.offAll(
          const Wrapper()); // remove all the pages on stack and push the page passed (other alternative is offAllNamed(routeName)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email already exists. Please login or create another account',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amber,
          ),
        );
      }
    }
  }

  addUser() async {
    try {
      final CollectionReference users = db.collection("users");
      final Map<String, Object> userFields = {
        'email': _email.trim(),
        'name': _name.trim(),
        'orders': [],
        'wishlist': [],
        'search_history': [],
      };
      await users.doc(_email.trim()).set(userFields);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Account created successfully. Re-directing to Login Screen'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } on FirebaseException catch (e) {
      e.printError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Sign up to $appname"
                    .text
                    .fontFamily(bold)
                    .white
                    .size(18)
                    .make(),
                15.heightBox,
                Column(
                  children: [
                    CustomTextField(
                        hint: nameHint,
                        title: name,
                        controller: _nameController,
                        onChanged: (name) {
                          setState(() {
                            _name = name;
                          });
                        },
                        validator: validateName),
                    CustomTextField(
                        hint: emailHint,
                        title: email,
                        controller: _emailController,
                        onChanged: (email) {
                          setState(() {
                            _email = email;
                          });
                        },
                        validator: _validateEmail),
                    CustomTextField(
                        hint: passwordHint,
                        title: password,
                        controller: _passwordController,
                        onChanged: (password) {
                          setState(() {
                            _password = password;
                          });
                        },
                        validator: _validatePassword),
                    CustomTextField(
                        hint: passwordHint,
                        title: retypePassword,
                        controller: _reTypePasswordController,
                        onChanged: (reTypePassword) {
                          setState(() {});
                        },
                        validator: _validatePassword),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {}, child: forgetPass.text.make())),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )),
                              TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                      fontFamily: regular, color: redColor)),
                              TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                      fontFamily: regular, color: fontGrey)),
                              TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                      fontFamily: regular, color: redColor))
                            ],
                          )),
                        ),
                      ],
                    ),
                    5.heightBox,
                    ourButton(
                      color: isCheck == true ? redColor : lightGrey,
                      title: signup,
                      textColor: whiteColor,
                      onPress: _submitForm,
                    ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    //wrapping into gesture detector of velocity X

                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: alreadyHaveAccount,
                              style: TextStyle(
                                fontFamily: bold,
                                color: fontGrey,
                              )),
                          TextSpan(
                              text: login,
                              style: TextStyle(
                                fontFamily: bold,
                                color: redColor,
                              ))
                        ],
                      ),
                    ).onTap(() {
                      Get.back();
                    }),
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
