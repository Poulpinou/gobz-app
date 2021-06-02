import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/steps/StepEditionBloc.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/view/components/forms/steps/StepForm.dart';

class EditStepPage extends StatelessWidget {
  final Step step;

  const EditStepPage({Key? key, required this.step}) : super(key: key);

  static Route<Step> route(Step step) {
    return MaterialPageRoute<Step>(
        builder: (_) => EditStepPage(
              step: step,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepEditionBloc>(
      create: (context) => StepEditionBloc(
        context.read<StepRepository>(),
        step: step,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edition de ${step.name}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: StepForm(
              step: step,
              onValidate: (step) => Navigator.pop(context, step),
            ),
          ),
        ),
      ),
    );
  }
}
