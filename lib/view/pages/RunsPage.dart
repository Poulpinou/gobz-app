import 'package:flutter/material.dart';
import 'package:gobz_app/view/components/specific/RunListComponent.dart';

class RunsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RunsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RunListComponent(),
    );
  }
}
