import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;

  Accordion({required this.title, required this.content});

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: widget.title,
            trailing: IconButton(
              icon: Icon(_showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
            ),
          ),
          _showContent
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: widget.content,
                  color: Theme.of(context).secondaryHeaderColor,
                )
              : Container()
        ],
      ),
    );
  }
}
