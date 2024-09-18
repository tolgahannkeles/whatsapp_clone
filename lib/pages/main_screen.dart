import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/pages/requests_tab.dart';
import 'package:whatsapp_clone/pages/chat_tab.dart';
import 'package:whatsapp_clone/pages/updates_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = "/main";

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
          actions: getActions(),
        ),
        body: PageView(
          onPageChanged: (value) => _updateCurrentIndex(value),
          controller: _pageController,
          children: const [
            ChatTab(),
            FriendsTab(),
            RequestsTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: lightBlue,
          items: const [
            BottomNavigationBarItem(
                icon: ChatTab.icon,
                label: ChatTab.label,
                backgroundColor: darkBlue),
            BottomNavigationBarItem(
                icon: FriendsTab.icon,
                label: FriendsTab.label,
                backgroundColor: darkBlue),
            BottomNavigationBarItem(
                icon: RequestsTab.icon,
                label: RequestsTab.label,
                backgroundColor: darkBlue),
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

  List<Widget> getActions() {
    switch (_currentIndex) {
      case 0:
        return const ChatTab().actions;
      case 1:
        return const FriendsTab().actions;
      case 2:
        return const RequestsTab().actions;
      default:
        return [];
    }
  }
}
