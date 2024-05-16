import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/nav/main_menu.dart';
import 'package:eventtracking/providers/user_management_provider.dart';
import 'package:eventtracking/screens/auth/register.dart';
import 'package:eventtracking/widgets/app_large_text.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  bool isLoading = false;

  _userLoginFnc() async {
    final userAuthProvider =
        Provider.of<UserAuthProvider>(context, listen: false);
    if (userPasswordController.text.isEmpty &&
        userPasswordController.text.isEmpty) {
      return;
    }
    var data = {
      "username": userNameController.text,
      "password": userPasswordController.text
    };

    setState(() {
      isLoading = true;
    });

    try {
      final res = await userAuthProvider.loginUser(
          userNameController.text, userPasswordController.text);
      print(res);
      if (res) {
        print("object=========================");
        Fluttertoast.showToast(
            msg: "Login Successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainPage()));
      } else {
        await Fluttertoast.showToast(
            msg: "Wrong credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: "Error:Invalid login credentials",
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
                        AppLargeText(text: "Login"),
                        AppSmallText(text: "Login to get started")
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
                          },
                          borderRadius: BorderRadius.circular(14.0),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    " Log In",
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
                                  builder: (_) => const RegisterScreen()));
                        },
                        child: Text(
                          "Sign Up",
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
