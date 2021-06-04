import 'package:flutter/material.dart';
import 'package:gobz_app/models/enums/RunStatus.dart';

class RunStatusDisplay extends StatelessWidget {
  final RunStatus status;
  final double paddingSize;

  const RunStatusDisplay({
    Key? key,
    required this.status,
    this.paddingSize = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Text(status.name),
      ),
      color: status.displayColor,
    );
  }
}
