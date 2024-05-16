import 'dart:convert';

import 'package:eventtracking/api/api.dart';
import 'package:eventtracking/constants/app_constants.dart';
import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/screens/auth/login.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  bool isLoading = false;
  bool isArtist = false;

  _userLoginFnc() async {
    if (userPasswordController.text.isEmpty &&
        userNameController.text.isEmpty &&
        userEmailController.text.isEmpty) {
      return;
    }
    var data = {
      "username": userNameController.text,
      "email": userEmailController.text,
      "password": userPasswordController.text,
      "role": isArtist ? 2 : 3
    };

    print(data);
    setState(() {
      isLoading = true;
    });
    try {
      var res = await CallApi()
          .authenticatedRequest(data, AppConstants.apiUserRegistration, 'post');
      print(res);
      var body = json.decode(res);

      if (body['save']) {
        print("object=========================");
        Fluttertoast.showToast(
            msg: "Registration Successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        await Fluttertoast.showToast(
            msg: "Email or username already exists!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error: Registration failed try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onArtistChanged(bool? newValue) => setState(() {
        isArtist = newValue!;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.1,
                  // ),
                  Center(
                    child: Image.asset(
                      'assets/gitarWn.png',
                      height: 300,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        AppLargeText(text: "Sign Up"),
                        AppSmallText(text: "Create Account to get started")
                      ],
                    ),
                  ),
                  Center(
                      child: Form(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: userEmailController,
                          // validator: validateUsername,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                            fillColor: AppColors.mainColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                14,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Email",
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: userNameController,
                          // validator: validateUsername,
                          keyboardType: TextInputType.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                            fillColor: AppColors.mainColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                14,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Username",
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: userPasswordController,
                          obscureText: true,
                          // validator: validatePassword,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.lock),
                            fillColor: AppColors.mainColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                14,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "password",
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            AppSmallText(text: "Register as an Artist"),
                            Checkbox(
                                value: isArtist, onChanged: _onArtistChanged)
                          ],
                        )
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 32,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(24.0),
                    elevation: 0,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _userLoginFnc();
                            // OtpScreen(
                            //   isCorp: "citizen",
                            //   userId: "",
                            // ),
                          },
                          borderRadius: BorderRadius.circular(14.0),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create account",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an accout? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: Text(
                          "Log In",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
