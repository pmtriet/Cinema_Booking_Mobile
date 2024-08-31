import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(backgroundColor),
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Image.asset('assets/images/appname.png'),
                const SizedBox(
                  height: 85,
                ),
                Image.asset('assets/images/logo.png'),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'MBooking hello!',
                  style: TextStyle(
                      color: Color(textColor),
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Enjoy your favorite movies',
                  style: TextStyle(color: Color(textColor), fontSize: 16),
                ),
                const Spacer(),
                AppButton(
                  title: "Login",
                  onTextButtonPressed: () {
                    context.push(RouteName.login);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(appColor),
                      backgroundColor: const Color(backgroundColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(btnBorderRadius),
                        side: const BorderSide(
                          color: Color(appColor),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: const Text('Register'),
                    onPressed: () {
                      context.push(RouteName.register);
                    },
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'By sign in or sign up, you agree to our Terms of Service and Privac y Policy',
                  style: TextStyle(
                    color: Color(0xffB3B3B3),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
