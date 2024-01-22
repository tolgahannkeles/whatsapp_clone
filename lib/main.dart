import 'package:flutter/material.dart';
import 'package:whatsapp_clone/pages/main_screen.dart';

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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
        appBarTheme: const AppBarTheme(backgroundColor: lightBlue),
      ),
      home: const MainScreen(),
    );
  }
}
