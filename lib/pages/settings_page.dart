import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/auth_transactions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = "/settings";
  static const String label = "Settings";

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService.logout();
                  Navigator.of(context).pushReplacementNamed("/login");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              child: const Text("LOGOUT"))
        ],
      ),
    );
  }
}
