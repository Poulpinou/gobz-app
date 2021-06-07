import 'package:flutter/material.dart';

class SectionDisplay extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? action;
  final Widget child;

  const SectionDisplay({
    Key? key,
    required this.title,
    required this.child,
    this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: color,
                  )
                : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6?.copyWith(color: color),
                ),
              ),
            ),
            action ?? Container(),
          ],
        ),
        Divider(
          height: 5,
          thickness: 1,
          color: color,
        ),
        Card(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
