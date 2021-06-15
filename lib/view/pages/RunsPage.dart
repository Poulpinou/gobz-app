import 'package:flutter/material.dart' hide Step;
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/view/components/forms/runs/RunForm.dart';
import 'package:gobz_app/view/components/specific/runs/RunListComponent.dart';

import 'generic/FormPage.dart';

class RunsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RunsPage());
  }

  void _createRun(BuildContext context) async {
    final Run? run = await Navigator.push(
      context,
      FormPage.route<Run>(
        NewRunForm(
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Nouveau Run",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RunListComponent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createRun(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
