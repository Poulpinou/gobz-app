import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/runs/RunEditionBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/Run.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/enums/FormMode.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/data/repositories/RunRepository.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';
import 'package:gobz_app/view/components/forms/FormComponent.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/SectionDisplay.dart';
import 'package:gobz_app/view/widgets/selectors/MultiSelector.dart';
import 'package:gobz_app/view/widgets/selectors/SimpleSelector.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

part 'fields/LimitDateField.dart';

part 'fields/StepField.dart';

part 'fields/TasksField.dart';

class NewRunForm extends _RunFormBase {
  NewRunForm({Function(Run run)? onValidate}) : super(FormMode.CREATE, onValidate);

  @override
  RunEditionEvent get submissionEvent => RunEditionEvents.create();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunEditionBloc>(
      create: (context) => RunEditionBloc.creation(context.read<RunRepository>()),
      child: super.build(context),
    );
  }
}

abstract class _RunFormBase extends StatelessWidget implements FormComponent<Run> {
  final FormMode formMode;
  final Function(Run run)? onValidate;

  const _RunFormBase(this.formMode, this.onValidate, {Key? key}) : super(key: key);

  bool get isCreation => formMode == FormMode.CREATE;

  RunEditionEvent get submissionEvent;

  @override
  Widget build(BuildContext context) {
    return BlocHandler<RunEditionBloc, RunEditionState>.custom(
      mapEventToNotification: (state) {
        if (state.isSubmissionSuccess && state.run != null) {
          return BlocNotification.success("${isCreation ? 'Création' : 'Sauvegarde'} du run réussie!")
              .withPostAction((context) => onValidate?.call(state.run!));
        }
      },
      child: BlocBuilder<RunEditionBloc, RunEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${isCreation ? 'Création' : 'Sauvegarde'} du run..."),
                Container(height: 10),
                LinearProgressIndicator(),
              ],
            );
          }

          return Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionDisplay(
                title: "Cibles",
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StepField(),
                    _TasksField(),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              SectionDisplay(
                title: "Contraintes",
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LimitDateField(),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(12)),
              BlocBuilder<RunEditionBloc, RunEditionState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) => ElevatedButton(
                  key: const Key("runForm_submit"),
                  onPressed:
                      state.status.isValidated ? () => context.read<RunEditionBloc>().add(submissionEvent) : null,
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
