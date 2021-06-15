import 'package:flutter/material.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';

class SimpleSelector<T> extends StatelessWidget {
  final Future<List<T>> dataFuture;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final void Function(T selected)? onSelect;
  final void Function()? onCancel;
  final Widget? title;

  const SimpleSelector({
    Key? key,
    required this.dataFuture,
    required this.itemBuilder,
    this.onSelect,
    this.onCancel,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title ?? Container(),
      ),
      body: FutureBuilder<List<T>>(
        future: dataFuture,
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
                (index) => ListTile(
                  title: itemBuilder(context, data[index]),
                  onTap: () => onSelect?.call(data[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
