import 'package:flutter/material.dart';

class NewProjectPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NewProjectPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouveau projet"),
      ),
      body: Text("New project"),
    );
  }
}
