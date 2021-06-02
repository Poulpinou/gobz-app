import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/projects/ProjectEditionBloc.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

part 'fields/DescriptionField.dart';
part 'fields/IsSharedField.dart';
part 'fields/NameField.dart';

class ProjectForm extends StatelessWidget {
  final Project? project;
  final Function(Project)? onValidate;
  final bool isCreation;

  const ProjectForm({Key? key, Project? project, this.onValidate})
      : this.project = project,
        this.isCreation = project == null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocHandler<ProjectEditionBloc, ProjectEditionState>.custom(
      mapErrorToNotification: (state) {
        if (state.hasBeenUpdated && state.project != null) {
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
                          ? () => context.read<ProjectEditionBloc>().add(isCreation
                              ? ProjectEditionEvents.creationFormSubmitted()
                              : ProjectEditionEvents.updateFormSubmitted())
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
