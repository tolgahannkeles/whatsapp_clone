import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/pages/calls_tab.dart';
import 'package:whatsapp_clone/pages/chat_tab.dart';
import 'package:whatsapp_clone/pages/updates_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WhatsApp"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
          ],
        ),
        body: PageView(
          onPageChanged: (value) => _updateCurrentIndex(value),
          controller: _pageController,
          children: const [
            ChatTab(),
            UpdatesTab(),
            CallsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.message_rounded),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: lightBlue,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: "Chats", backgroundColor: darkBlue),
            BottomNavigationBarItem(
                icon: Icon(Icons.update_rounded),
                label: "Updates",
                backgroundColor: darkBlue),
            BottomNavigationBarItem(
                icon: Icon(Icons.call), label: "Calls", backgroundColor: darkBlue),
          ],
          type: BottomNavigationBarType.shifting,
          selectedItemColor: darkGreen,
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
              _pageController.jumpToPage(value);
            });
          },
        ));
  }
}
