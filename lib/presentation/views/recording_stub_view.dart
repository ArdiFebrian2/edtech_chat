import 'package:flutter/material.dart';

class RecordingStubView extends StatelessWidget {
  const RecordingStubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watch Recording")),
      body: const Center(
        child: Text("This is a stub for 'Watch Recording'"),
      ),
    );
  }
}
