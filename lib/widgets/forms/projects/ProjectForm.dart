import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/ProjectEditionBloc.dart';
import 'package:gobz_app/models/Project.dart';

part 'fields/NameField.dart';

part 'fields/DescriptionField.dart';

part 'fields/IsSharedField.dart';

class CreateProjectForm extends StatelessWidget {
  final Function(Project?)? onCreated;

  const CreateProjectForm({Key? key, this.onCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectEditionBloc, ProjectEditionState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("La création du projet a échoué")),
            );
        } else if (state.formStatus.isSubmissionSuccess) {
          onCreated?.call(state.project);
        }
      },
      child: BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
        buildWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        builder: (context, state) => state.formStatus.isSubmissionInProgress
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Création du projet..."),
                  Container(height: 10),
                  LinearProgressIndicator(),
                ],
              )
            : Column(
                children: [
                  _NameField(),
                  const Padding(padding: EdgeInsets.all(8)),
                  _DescriptionField(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _IsSharedField(),
                  const Padding(padding: EdgeInsets.all(12)),
                  BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return ElevatedButton(
                            key: const Key("projectForm_submit"),
                            onPressed: state.status.isValidated
                                ? () => context
                                    .read<ProjectEditionBloc>()
                                    .add(CreateProjectFormSubmitted())
                                : null,
                            child: const Text("Créer"));
                      }),
                ],
              ),
      ),
    );
  }
}

class UpdateProjectForm extends StatelessWidget {
  final Project project;
  final Function(Project)? onValidate;

  const UpdateProjectForm({Key? key, required this.project, this.onValidate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectEditionBloc, ProjectEditionState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("La sauvegarde du projet a échoué")),
            );
        } else if (state.formStatus.isSubmissionSuccess) {
          onValidate?.call(state.project!);
        }
      },
      child: BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
        buildWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        builder: (context, state) => state.formStatus.isSubmissionInProgress
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sauvegarde du projet..."),
                  Container(height: 10),
                  LinearProgressIndicator(),
                ],
              )
            : Column(
                children: [
                  _NameField(initialValue: state.name.value),
                  const Padding(padding: EdgeInsets.all(8)),
                  _DescriptionField(initialValue: state.description.value),
                  const Padding(padding: EdgeInsets.all(12)),
                  _IsSharedField(initialValue: state.isShared),
                  const Padding(padding: EdgeInsets.all(12)),
                  BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return ElevatedButton(
                            key: const Key("projectForm_submit"),
                            onPressed: state.status.isValidated
                                ? () => context
                                    .read<ProjectEditionBloc>()
                                    .add(UpdateProjectFormSubmitted())
                                : null,
                            child: const Text("Sauvegarder"));
                      })
                ],
              ),
      ),
    );
  }
}
