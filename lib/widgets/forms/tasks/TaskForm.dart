import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/TaskEditionBloc.dart';
import 'package:gobz_app/models/Task.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';

part 'fields/TextField.dart';

class TaskForm extends StatelessWidget {
  final Task? task;
  final Function(Task task)? onValidate;
  final Function? onCancel;
  final bool isCreation;

  const TaskForm({Key? key, this.task, this.onValidate, this.onCancel})
      : this.isCreation = task == null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocHandler<TaskEditionBloc, TaskEditionState>.simple(
        child: BlocListener<TaskEditionBloc, TaskEditionState>(
      listener: (context, state) {
        if (state.hasBeenUpdated && state.task != null) {
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
                    onPressed: state.status.isValidated
                        ? () => context.read<TaskEditionBloc>().add(isCreation
                            ? TaskEditionEvents.createFormSubmitted()
                            : TaskEditionEvents.updateFormSubmitted())
                        : null,
                  ),
                ),
              ],
            );
          }),
    ));
  }
}
