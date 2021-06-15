part of '../RunForm.dart';

class _StepField extends StatelessWidget {
  final Step? initialValue;

  const _StepField({Key? key, this.initialValue}) : super(key: key);

  void _selectStep(BuildContext context) async {
    // TODO: Simplify (can be generic?)
    final Step? step = await Navigator.push<Step?>(
      context,
      MaterialPageRoute<Step?>(
        // Select Project
        builder: (context) => SimpleSelector<Project>(
          dataFuture: context.read<ProjectRepository>().getAllProjects(),
          itemBuilder: (context, project) => Text(project.name),
          onSelect: (project) async {
            final Step? step = await Navigator.push<Step?>(
              context,
              MaterialPageRoute<Step?>(
                // Select Chapter
                builder: (context) => SimpleSelector<Chapter>(
                  title: Text(project.name),
                  dataFuture: context.read<ChapterRepository>().getChapters(project.id),
                  itemBuilder: (context, chapter) => Text(chapter.name),
                  onSelect: (chapter) async {
                    final Step? step = await Navigator.push<Step?>(
                      context,
                      MaterialPageRoute<Step?>(
                        // Select Step
                        builder: (context) => SimpleSelector<Step>(
                          title: Text("${project.name} > ${chapter.name}"),
                          dataFuture: context.read<StepRepository>().getSteps(chapter.id),
                          itemBuilder: (context, step) => Text(step.name),
                          onSelect: (step) {
                            Navigator.pop(context, step);
                          },
                        ),
                      ),
                    );

                    if (step != null) {
                      Navigator.pop(context, step);
                    }
                  },
                ),
              ),
            );

            if (step != null) {
              Navigator.pop(context, step);
            }
          },
        ),
      ),
    );

    if (step != null) {
      context.read<RunEditionBloc>().add(RunEditionEvents.stepChanged(step));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunEditionBloc, RunEditionState>(
      buildWhen: (previous, current) => previous.step != current.step,
      builder: (context, state) => Row(
        children: [
          Expanded(
            child: TextField(
              key: Key('runForm_stepField'),
              controller: TextEditingController(text: state.step.value != null ? state.step.value!.name : ""),
              decoration: InputDecoration(
                labelText: 'Étape',
                errorText: state.step.invalid ? state.step.error?.message : null,
                hintText: "Sélectionnez une étape",
              ),
              readOnly: true,
              onTap: () => _selectStep(context),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => _selectStep(context),
          ),
        ],
      ),
    );
  }
}
