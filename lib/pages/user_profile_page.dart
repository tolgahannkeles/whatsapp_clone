import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/models/user.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  static const routeName = "/profile";
  static const String label = "Profile";
  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  User? currentUser;
  @override
  void initState() {
    UserTransactions.getLocalUser().then((value) {
      setState(() {
        currentUser = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text("Username -> ${currentUser?.username}"),
        Text("Emails -> ${currentUser?.email.toString()}"),
        Text("Picture -> ${currentUser?.profilePicture}"),
      ]),
    );
  }
}
