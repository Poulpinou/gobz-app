import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String value) onChanged;

  const SearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  hintText: "Chercher un projet",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
