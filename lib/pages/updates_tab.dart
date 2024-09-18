import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/friend.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});
  static const Icon icon = Icon(Icons.person_search_rounded);
  static const String label = "Friends";
  static const String routeName = "/friends";
  List<Widget> get actions => [];

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  TextEditingController usernameContoller = TextEditingController();
  List<Friend> suggestions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: loginTextField(
              usernameContoller, "Search", const Icon(Icons.search)),
        ),
        actions: widget.actions,
      ),
      body: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) => suggestionItem(suggestions[index]),
      ),
    );
  }

  Widget suggestionItem(Friend friend) {
    return ListTile(
      title: Text(friend.username),
      trailing: friend.friendshipStatus == null
          ? ElevatedButton(
              onPressed: () async {
                try {
                  await UserTransactions.sendFriendRequest(friend.id).then(
                    (value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Friend request sent"),
                          ),
                        );
                      }
                    },
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Add"),
            )
          : null,
      subtitle: Text(friend.friendshipStatus.name),
    );
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

  @override
  void initState() {
    super.initState();
    // TextEditingController'a listener ekliyoruz
    usernameContoller.addListener(() async {
      String enteredText = usernameContoller.text;
      // Her text değiştiğinde tetiklenecek işlemler
      if (enteredText.isNotEmpty) {
        await UserTransactions.findUserByUsernameStartingWith(enteredText).then(
          (value) {
            setState(() {
              suggestions = value;
            });
          },
        );
      }
      // Burada suggestions listesini güncelleyebilirsiniz.
      // fetchSuggestions(enteredText);
    });
  }

  @override
  void dispose() {
    // Memory leak olmaması için controller'dan listener'ı kaldırıyoruz
    usernameContoller.dispose();
    super.dispose();
  }
}
