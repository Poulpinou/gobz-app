import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final String message;

  const CircularLoader(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), Container(width: 10), Text(message)],
      ),
    );
  }
}
