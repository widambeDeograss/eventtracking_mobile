import 'package:eventtracking/constants/custom_colors.dart';
import 'package:eventtracking/screens/auth/login.dart';
import 'package:eventtracking/widgets/app_small_text.dart';
import 'package:flutter/material.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bording.png"),
                    fit: BoxFit.contain,
                  ),
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
                  // boxShadow: List
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.maxFinite,
                child: AppSmallText(
                  text:
                      "Experience the ultimate journey through artistry with our innovative event tracking system.Seamlessly follow your favorite artists, discover new exhibitions, and stay up-to date with the latest cultural happenings—all at your fingertips. Immerse yourself in a world where creativity knows no bounds, and let our cutting-edge tracking technology guide you through a captivating exploration of artistic expression",
                  size: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.addsOn,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(
                    //       10), // Set border radius here
                    // ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: const Text(
                    "Get started",
                    style: TextStyle(
                        color: AppColors.textColor1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
