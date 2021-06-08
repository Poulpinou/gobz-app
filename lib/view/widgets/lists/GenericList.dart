import 'package:flutter/material.dart';

class GenericList<T> extends StatelessWidget {
  final List<T> data;
  final Function(BuildContext context, T dataItem) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final double bottomSpace;

  const GenericList({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.bottomSpace = 100,
    this.separatorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => itemBuilder(context, data[index]),
      itemCount: data.length,
      padding: EdgeInsets.only(bottom: bottomSpace),
      separatorBuilder: separatorBuilder ?? (_, __) => Container(),
    );
  }
}
