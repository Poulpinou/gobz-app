import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/steps/StepEditionBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/view/components/forms/steps/StepForm.dart';

class NewStepPage extends StatelessWidget {
  final Chapter chapter;

  const NewStepPage({Key? key, required this.chapter}) : super(key: key);

  static Route<Step> route(Chapter chapter) {
    return MaterialPageRoute<Step>(
        builder: (_) => NewStepPage(
              chapter: chapter,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepEditionBloc>(
      create: (context) => StepEditionBloc(
        context.read<StepRepository>(),
        chapterId: chapter.id,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nouvelle étape"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: StepForm(
              onValidate: (step) => Navigator.pop(context, step),
            ),
          ),
        ),
      ),
    );
  }
}
