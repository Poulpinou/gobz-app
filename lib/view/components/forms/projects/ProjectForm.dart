import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/projects/ProjectEditionBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/models/enums/FormMode.dart';
import 'package:gobz_app/data/repositories/ProjectRepository.dart';
import 'package:gobz_app/view/components/forms/FormComponent.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

part 'fields/DescriptionField.dart';
part 'fields/IsSharedField.dart';
part 'fields/NameField.dart';

class NewProjectForm extends _ProjectFormBase {
  NewProjectForm({Function(Project project)? onValidate}) : super(FormMode.CREATE, onValidate);

  @override
  ProjectEditionEvent get submissionEvent => ProjectEditionEvents.create();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectEditionBloc>(
      create: (_) => ProjectEditionBloc.creation(context.read<ProjectRepository>()),
      child: super.build(context),
    );
  }
}

class EditProjectForm extends _ProjectFormBase {
  final Project project;

  EditProjectForm({required this.project, Function(Project project)? onValidate}) : super(FormMode.EDIT, onValidate);

  @override
  ProjectEditionEvent get submissionEvent => ProjectEditionEvents.update();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectEditionBloc>(
      create: (_) => ProjectEditionBloc.edition(context.read<ProjectRepository>(), project),
      child: super.build(context),
    );
  }
}

abstract class _ProjectFormBase extends StatelessWidget implements FormComponent<Project> {
  final FormMode formMode;
  final Function(Project)? onValidate;

  const _ProjectFormBase(this.formMode, this.onValidate, {Key? key}) : super(key: key);

  bool get isCreation => formMode == FormMode.CREATE;

  ProjectEditionEvent get submissionEvent;

  @override
  Widget build(BuildContext context) {
    return BlocHandler<ProjectEditionBloc, ProjectEditionState>.custom(
      mapEventToNotification: (state) {
        if (state.isSubmissionSuccess && state.project != null) {
          return BlocNotification.success("${state.project!.name} ${isCreation ? 'créé' : 'sauvegardé'}!")
              .copyWith(postAction: (context) => onValidate?.call(state.project!));
        }
      },
      child: BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${isCreation ? 'Création' : 'Sauvegarde'} du projet..."),
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
              _IsSharedField(initialValue: state.isShared),
              const Padding(padding: EdgeInsets.all(12)),
              BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) {
                  return ElevatedButton(
                      key: const Key("projectForm_submit"),
                      onPressed: state.status.isValidated
                          ? () => context
                              .read<ProjectEditionBloc>()
                              .add(isCreation ? ProjectEditionEvents.create() : ProjectEditionEvents.update())
                          : null,
                      child: Text(isCreation ? "Créer" : "Sauvegarder"));
                },
              )
            ],
          );
        },
      ),
    );
  }
}
