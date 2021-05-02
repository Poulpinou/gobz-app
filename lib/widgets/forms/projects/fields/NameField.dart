part of '../ProjectForm.dart';

class _NameField extends StatefulWidget {
  final String? initialValue;

  const _NameField({Key? key, this.initialValue}) : super(key: key);

  _NameFieldState createState() => _NameFieldState(initialValue);
}

class _NameFieldState extends State<_NameField> {
  final bool _isEdition;
  final TextEditingController _controller;

  _NameFieldState(String? initialValue)
      : _isEdition = initialValue != null,
        _controller = TextEditingController(text: initialValue ?? "");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) => TextField(
        controller: _controller,
        key: Key('${_isEdition ? 'edit' : 'create'}_projectForm_nameField'),
        onChanged: (name) => context.read<ProjectEditionBloc>().add(ProjectNameChanged(name)),
        decoration: InputDecoration(labelText: 'Nom', errorText: state.name.invalid ? state.name.error?.message : null),
      ),
    );
  }
}
