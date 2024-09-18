import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/auth_transactions.dart';
import 'package:whatsapp_clone/database/shared_preferences_util.dart';
import 'package:whatsapp_clone/pages/login_page.dart';
import 'package:whatsapp_clone/pages/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SharedPreferencesUtil.getAccessToken().then((value) {
      if (value != null) {
        AuthService.isTokenValid(value).then((value) {
          if (value) {
            Navigator.popAndPushNamed(context, MainScreen.routeName);
          } else {
            Navigator.popAndPushNamed(context, LoginPage.routeName);
          }
        });
      } else {
        Navigator.popAndPushNamed(context, LoginPage.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
