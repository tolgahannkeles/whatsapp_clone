import 'package:flutter/material.dart';

class CallsTab extends StatefulWidget {
  const CallsTab({super.key});

  @override
  State<CallsTab> createState() => _CallsTabState();
}

class _CallsTabState extends State<CallsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Calls"),
    );
  }
}
