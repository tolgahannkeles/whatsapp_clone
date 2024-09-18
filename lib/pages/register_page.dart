import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/auth_transactions.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/pages/main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          registerTextField(
            emailController,
            "Email",
            const Icon(Icons.email_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: registerTextField(
              usernameController,
              "Username",
              const Icon(Icons.person_2_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: registerTextField(
              passwordController,
              "Password",
              const Icon(Icons.password_rounded),
            ),
          ),
          ElevatedButton.icon(
              onPressed: () async {
                try {
                  AuthService.register(emailController.text,
                          usernameController.text, passwordController.text)
                      .then(
                    (value) {
                      Navigator.popAndPushNamed(context, MainScreen.routeName);
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              label: const Text("REGISTER")),
        ],
      ),
    );
  }

  Widget registerTextField(
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
