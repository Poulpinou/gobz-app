import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/ProjectEditionBloc.dart';
import 'package:gobz_app/models/Project.dart';

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
        }
        else if(state.formStatus.isSubmissionSuccess){
          onCreated?.call(state.project);
          //Navigator.of(context).replace(oldRoute: NewProjectPage.route(), newRoute: ProjectPage.route(state.project!));
          //context.read<ProjectsBloc>().add(FetchProjectsRequested());
          //Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
        buildWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        builder: (context, state) => state.formStatus.isSubmissionInProgress
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Creation du projet..."),
                  Container(height: 10),
                  LinearProgressIndicator(),
                ],
              )
            : Column(
                children: [
                  _NameInput(),
                  const Padding(padding: EdgeInsets.all(8)),
                  _DescriptionInput(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _IsSharedInput(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _SubmitButton(),
                ],
              ),
      ),
    );
  }
}

class UpdateProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) => TextField(
        key: const Key('projectForm_nameInput'),
        onChanged: (name) =>
            context.read<ProjectEditionBloc>().add(ProjectNameChanged(name)),
        decoration: InputDecoration(
            labelText: 'Nom',
            errorText: state.name.invalid ? state.name.error?.message : null),
      ),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) => TextField(
        key: const Key('projectForm_descriptionInput'),
        onChanged: (description) => context
            .read<ProjectEditionBloc>()
            .add(ProjectDescriptionChanged(description)),
        decoration: InputDecoration(
          labelText: 'Description',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: state.description.invalid
              ? state.description.error?.message
              : null,
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
        ),
        minLines: 5,
        maxLines: 10,
      ),
    );
  }
}

class _IsSharedInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) => previous.isShared != current.isShared,
      builder: (context, state) => Row(
        children: [
          Checkbox(
            key: const Key('projectForm_isShared'),
            value: state.isShared,
            onChanged: (value) => context
                .read<ProjectEditionBloc>()
                .add(ProjectIsSharedChanged(value ?? false)),
          ),
          const Text('Public')
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ElevatedButton(
              key: const Key("projectForm_submit"),
              onPressed: state.status.isValidated
                  ? () => context
                      .read<ProjectEditionBloc>()
                      .add(CreateProjectFormSubmitted())
                  : null,
              child: const Text("Créer"));
        });
  }
}
