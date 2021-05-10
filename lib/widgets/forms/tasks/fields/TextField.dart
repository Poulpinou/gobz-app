part of '../TaskForm.dart';

class _TextField extends StatefulWidget {
  final String? initialValue;

  const _TextField({Key? key, this.initialValue}) : super(key: key);

  _TextFieldState createState() => _TextFieldState(initialValue);
}

class _TextFieldState extends State<_TextField> {
  final TextEditingController _controller;

  _TextFieldState(String? initialValue) : _controller = TextEditingController(text: initialValue ?? "");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskEditionBloc, TaskEditionState>(
      buildWhen: (previous, current) => previous.text != current.text,
      builder: (context, state) => TextField(
        controller: _controller,
        key: Key('taskForm_textField'),
        onChanged: (text) => context.read<TaskEditionBloc>().add(TaskEditionEvents.textChanged(text)),
        decoration: InputDecoration(
          hintText: "ex: Écrire une autre tâche",
          errorText: state.text.invalid ? state.text.error?.message : null,
        ),
      ),
    );
  }
}
