import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/StepEditionBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/widgets/forms/steps/StepForm.dart';

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
