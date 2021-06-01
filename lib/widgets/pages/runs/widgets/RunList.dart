import 'package:flutter/material.dart';
import 'package:gobz_app/models/Run.dart';

class RunList extends StatelessWidget {
  final List<Run> runs;
  final Function(BuildContext context, Run run) itemBuilder;
  final double bottomSpace;

  const RunList({
    Key? key,
    required this.runs,
    required this.itemBuilder,
    this.bottomSpace = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => itemBuilder(context, runs[index]),
      itemCount: runs.length,
      padding: EdgeInsets.only(bottom: bottomSpace),
    );
  }
}
