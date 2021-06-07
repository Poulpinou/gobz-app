part of '../ChapterForm.dart';

class _DescriptionField extends StatefulWidget {
  final String? initialValue;

  const _DescriptionField({Key? key, this.initialValue}) : super(key: key);

  _DescriptionFieldState createState() => _DescriptionFieldState(initialValue);
}

class _DescriptionFieldState extends State<_DescriptionField> {
  final TextEditingController _controller;

  _DescriptionFieldState(String? initialValue) : _controller = TextEditingController(text: initialValue);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
      buildWhen: (previous, current) => previous.description != current.description,
      builder: (context, state) => TextField(
        controller: _controller,
        key: Key('chapterForm_descriptionField'),
        onChanged: (description) =>
            context.read<ChapterEditionBloc>().add(ChapterEditionEvents.descriptionChanged(description)),
        decoration: InputDecoration(
          labelText: 'Description',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: state.description.invalid ? state.description.error?.message : null,
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
        ),
        minLines: 5,
        maxLines: 10,
      ),
    );
  }
}
