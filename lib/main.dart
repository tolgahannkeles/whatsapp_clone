import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/conversation.dart';
import 'package:whatsapp_clone/models/friend.dart';
import 'package:whatsapp_clone/pages/chat_screen.dart';
import 'package:whatsapp_clone/pages/create_chat_screen.dart';
import 'package:whatsapp_clone/pages/login_page.dart';
import 'package:whatsapp_clone/pages/main_screen.dart';
import 'package:whatsapp_clone/pages/profile_screen.dart';
import 'package:whatsapp_clone/pages/register_page.dart';
import 'package:whatsapp_clone/pages/settings_page.dart';
import 'package:whatsapp_clone/pages/splash_screen.dart';
import 'package:whatsapp_clone/pages/user_profile_page.dart';

void main() {
  runApp(const MyApp());
}

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
const Color darkGreen = Color.fromRGBO(18, 140, 126, 1);
const Color lightBlue = Color.fromRGBO(39, 52, 67, 1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
        appBarTheme: const AppBarTheme(backgroundColor: lightBlue),
      ),
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        MainScreen.routeName: (context) => const MainScreen(),
        SettingsPage.routeName: (context) => const SettingsPage(),
        CreateChatScreen.routeName: (context) => const CreateChatScreen(),
        SplashScreen.routeName: (context) => const SplashScreen(),
        UserProfilePage.routeName: (context) => const UserProfilePage(),
        WhatsappProfilePage.routeName: (context) => const WhatsappProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ChatScreen.routeName) {
          final args = settings.arguments as Conversation;
          return MaterialPageRoute(
            builder: (context) {
              return ChatScreen(
                conversation: args,
              );
            },
          );
        }
        return null;
      },
      home: const SplashScreen(),
    );
  }
}
