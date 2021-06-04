import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/steps/StepEditionBloc.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/models/enums/FormMode.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

import '../FormComponent.dart';

part 'fields/DescriptionField.dart';
part 'fields/NameField.dart';

class NewStepForm extends _StepFormBase {
  final int chapterId;

  NewStepForm({
    required this.chapterId,
    Function(Step step)? onValidate,
  }) : super(FormMode.CREATE, onValidate);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepEditionBloc>(
      create: (context) => StepEditionBloc.creation(context.read<StepRepository>()),
      child: super.build(context),
    );
  }

  @override
  StepEditionEvent get submissionEvent => StepEditionEvents.create(chapterId);
}

class EditStepForm extends _StepFormBase {
  final Step step;

  EditStepForm({
    required this.step,
    Function(Step step)? onValidate,
  }) : super(FormMode.EDIT, onValidate);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepEditionBloc>(
      create: (context) => StepEditionBloc.edition(
        context.read<StepRepository>(),
        step,
      ),
      child: super.build(context),
    );
  }

  @override
  StepEditionEvent get submissionEvent => StepEditionEvents.update();
}

abstract class _StepFormBase extends StatelessWidget implements FormComponent<Step> {
  final FormMode formMode;
  final Function(Step)? onValidate;

  const _StepFormBase(this.formMode, this.onValidate, {Key? key}) : super(key: key);

  bool get isCreation => formMode == FormMode.CREATE;

  StepEditionEvent get submissionEvent;

  @override
  Widget build(BuildContext context) {
    return BlocHandler<StepEditionBloc, StepEditionState>.custom(
      mapEventToNotification: (state) {
        if (state.isSubmissionSuccess && state.step != null) {
          return BlocNotification.success("${isCreation ? 'Création' : 'Sauvegarde'} de ${state.step!.name} réussie!")
              .copyWith(
            postAction: (context) => onValidate?.call(state.step!),
          );
        }
      },
      child: BlocBuilder<StepEditionBloc, StepEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${isCreation ? 'Création' : 'Sauvegarde'} de l'étape..."),
                Container(height: 10),
                LinearProgressIndicator(),
              ],
            );
          }

          return Column(
            children: [
              _NameField(initialValue: state.name.value),
              const Padding(padding: EdgeInsets.all(8)),
              _DescriptionField(initialValue: state.description.value),
              const Padding(padding: EdgeInsets.all(12)),
              BlocBuilder<StepEditionBloc, StepEditionState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) => ElevatedButton(
                  key: const Key("stepForm_submit"),
                  onPressed:
                      state.status.isValidated ? () => context.read<StepEditionBloc>().add(submissionEvent) : null,
                  child: Text(isCreation ? 'Créer' : 'Sauvegarder'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
