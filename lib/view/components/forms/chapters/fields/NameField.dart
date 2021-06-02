part of '../ChapterForm.dart';

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
    return BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) => TextField(
        controller: _controller,
        key: Key('chapterForm_nameField'),
        onChanged: (name) => context.read<ChapterEditionBloc>().add(ChapterEditionEvents.nameChanged(name)),
        decoration: InputDecoration(labelText: 'Nom', errorText: state.name.invalid ? state.name.error?.message : null),
      ),
    );
  }
}
