import 'package:flutter/material.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';

class MultiSelector<T> extends StatefulWidget {
  final Future<List<T>> dataFuture;
  final Widget Function(BuildContext context, T item, bool selected) itemBuilder;
  final void Function(List<T> selected) onValidate;
  final void Function()? onCancel;
  final Widget? title;
  final List<T>? selected;

  const MultiSelector({
    Key? key,
    required this.dataFuture,
    required this.itemBuilder,
    required this.onValidate,
    this.onCancel,
    this.title,
    this.selected,
  }) : super(key: key);

  @override
  _MultiSelectorState<T> createState() => _MultiSelectorState<T>();
}

class _MultiSelectorState<T> extends State<MultiSelector<T>> {
  late List<T> _selected = widget.selected ?? <T>[];

  void _select(T target) {
    if (_selected.contains(target)) {
      setState(() {
        _selected = _selected.where((item) => item != target).toList();
      });
    } else {
      setState(() {
        _selected = [
          ..._selected,
          target,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title ?? Container(),
        actions: [
          TextButton(
            onPressed: () => widget.onValidate.call(_selected),
            child: Text("Confirmer (${_selected.length})"),
          )
        ],
      ),
      body: FutureBuilder<List<T>>(
          future: widget.dataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return FetchFailure(message: "La récupération des données a échoué");
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return CircularLoader("Chargement des données...");
            }

            final List<T> data = snapshot.data!;

            return ListView(
              shrinkWrap: true,
              children: [
                ...List.generate(
                  data.length,
                  (index) {
                    final T item = data[index];
                    final bool selected = _selected.contains(item);

                    if (item is Task) {
                      print("${item.text}: $selected");
                    }

                    return ListTile(
                      title: widget.itemBuilder(context, item, selected),
                      selected: selected,
                      onTap: () => _select(item),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
