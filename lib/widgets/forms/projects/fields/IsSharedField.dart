part of '../ProjectForm.dart';

class _IsSharedField extends StatelessWidget {
  final bool? initialValue;

  const _IsSharedField({Key? key, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditionBloc, ProjectEditionState>(
      buildWhen: (previous, current) => previous.isShared != current.isShared,
      builder: (context, state) => Row(
        children: [
          Checkbox(
            key: const Key('projectForm_isShared'),
            value: state.isShared,
            onChanged: (value) =>
                context.read<ProjectEditionBloc>().add(ProjectEditionEvents.isSharedChanged(value ?? false)),
          ),
          const Text('Public')
        ],
      ),
    );
  }
}
