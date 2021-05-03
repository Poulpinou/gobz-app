part of '../ProjectForm.dart';

class _NameField extends StatefulWidget {
  final String? initialValue;

  const _NameField({Key? key, this.initialValue}) : super(key: key);

  _NameFieldState createState() => _NameFieldState(initialValue);
}

class _NameFieldState extends State<_NameField> {
  final TextEditingController _controller;

  _NameFieldState(String? initialValue) : _controller = TextEditingController(text: initialValue ?? "");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) => TextField(
        controller: _controller,
        key: Key('projectForm_nameField'),
        onChanged: (name) => context.read<ProjectEditionBloc>().add(ProjectEditionEvents.nameChanged(name)),
        decoration: InputDecoration(labelText: 'Nom', errorText: state.name.invalid ? state.name.error?.message : null),
      ),
    );
  }
}
