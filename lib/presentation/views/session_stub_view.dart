import 'package:flutter/material.dart';

class SessionStubView extends StatelessWidget {
  const SessionStubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Session")),
      body: const Center(
        child: Text("This is a stub for 'Join Session'"),
      ),
    );
  }
}
