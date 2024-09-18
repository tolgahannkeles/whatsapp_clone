import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/auth_transactions.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/pages/main_screen.dart';
import 'package:whatsapp_clone/pages/register_page.dart';
import 'package:whatsapp_clone/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameContoller = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginTextField(usernameContoller, Constants.username,
                  const Icon(Icons.person_2_rounded)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: loginTextField(passwordContoller, Constants.password,
                    const Icon(Icons.password_rounded)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton.icon(
                  onPressed: onLoginClicked,
                  label: const Text(Constants.login),
                ),
              ),
              TextButton(
                  onPressed: onRegisterClicked,
                  child: const Text(Constants.register)),
            ],
          ),
        ),
      ),
    );
  }

  void onRegisterClicked() {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  Future<void> onLoginClicked() async {
    try {
      AuthService.login(usernameContoller.text, passwordContoller.text).then(
        (value) {
          Navigator.popAndPushNamed(context, MainScreen.routeName);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  Widget loginTextField(
      TextEditingController controller, String hint, Icon prefix) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: lightBlue,
        hintText: hint,
        contentPadding: EdgeInsets.zero,
        prefixIcon: prefix,
        prefixIconColor: Colors.white,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
