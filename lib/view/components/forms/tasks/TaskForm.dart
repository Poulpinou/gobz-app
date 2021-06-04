import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/tasks/TaskEditionBloc.dart';
import 'package:gobz_app/data/models/Task.dart';
import 'package:gobz_app/data/models/enums/FormMode.dart';
import 'package:gobz_app/data/repositories/TaskRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

import '../FormComponent.dart';

part 'fields/TextField.dart';

class NewTaskForm extends _TaskFormBase {
  final int stepId;

  NewTaskForm({required this.stepId, Function(Task task)? onValidate, Function? onCancel})
      : super(FormMode.CREATE, onValidate, onCancel);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskEditionBloc>(
      create: (context) => TaskEditionBloc.creation(context.read<TaskRepository>()),
      child: super.build(context),
    );
  }

  @override
  TaskEditionEvent get submissionEvent => TaskEditionEvents.create(stepId);
}

class EditTaskForm extends _TaskFormBase {
  final Task task;

  EditTaskForm({required this.task, Function(Task task)? onValidate, Function? onCancel})
      : super(FormMode.EDIT, onValidate, onCancel);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskEditionBloc>(
      create: (context) => TaskEditionBloc.edition(
        context.read<TaskRepository>(),
        task,
      ),
      child: super.build(context),
    );
  }

  @override
  TaskEditionEvent get submissionEvent => TaskEditionEvents.update();
}

abstract class _TaskFormBase extends StatelessWidget implements FormComponent<Task> {
  final FormMode formMode;
  final Function(Task)? onValidate;
  final Function? onCancel;

  const _TaskFormBase(
    this.formMode,
    this.onValidate,
    this.onCancel, {
    Key? key,
  }) : super(key: key);

  bool get isCreation => formMode == FormMode.CREATE;

  TaskEditionEvent get submissionEvent;

  @override
  Widget build(BuildContext context) {
    return BlocHandler<TaskEditionBloc, TaskEditionState>.simple(
        child: BlocListener<TaskEditionBloc, TaskEditionState>(
      listener: (context, state) {
        if (state.isSubmissionSuccess && state.task != null) {
          onValidate?.call(state.task!);
        }
      },
      child: BlocBuilder<TaskEditionBloc, TaskEditionState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${isCreation ? 'Création' : 'Sauvegarde'} de la tâche..."),
                  Container(height: 10),
                  LinearProgressIndicator(),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                    child: _TextField(
                  initialValue: state.text.value,
                )),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => onCancel?.call(),
                ),
                BlocBuilder<TaskEditionBloc, TaskEditionState>(
                  buildWhen: (previous, current) => previous.status != current.status,
                  builder: (context, state) => IconButton(
                    icon: Icon(Icons.check),
                    onPressed:
                        state.status.isValidated ? () => context.read<TaskEditionBloc>().add(submissionEvent) : null,
                  ),
                ),
              ],
            );
          }),
    ));
  }
}
