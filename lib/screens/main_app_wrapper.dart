import 'package:flutter/material.dart';
import 'package:OneBrain/screens/home/home_screen.dart';

import '../utils/app_constants.dart';
import '../utils/shared_preference_util.dart';
import 'authentication/login/login_screen.dart';

class MainAppWrapper extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    await SharedPreferenceUtil.getInstance();
    return SharedPreferenceUtil.getBool(isLoginKey);
  }

  const MainAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Error initializing app")),
          );
        } else {
          bool isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const HomeScreen() : const LoginScreen();
        }
      },
    );
  }

  callScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferenceUtil.getBool(isLoginKey) == true
          ? HomeScreen()
          : LoginScreen();
    });
  }
}
