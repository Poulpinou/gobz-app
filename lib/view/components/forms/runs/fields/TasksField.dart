part of '../RunForm.dart';

class _TasksField extends StatelessWidget {
  final List<Task>? initialValue;

  const _TasksField({Key? key, this.initialValue}) : super(key: key);

  void _selectTasks(BuildContext context, RunEditionState state) async {
    final List<Task>? tasks = await Navigator.push<List<Task>>(
      context,
      MaterialPageRoute(
        builder: (context) => MultiSelector<Task>(
          dataFuture: context.read<TaskRepository>().getTasks(state.step.value!.id),
          selected: state.tasks.value,
          itemBuilder: (context, task, selected) => Row(
            children: [
              selected ? Icon(Icons.check) : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(task.text),
                ),
              ),
            ],
          ),
          onValidate: (tasks) {
            Navigator.pop(context, tasks);
          },
        ),
      ),
    );

    if (tasks != null) {
      context.read<RunEditionBloc>().add(RunEditionEvents.tasksChanged(tasks));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunEditionBloc, RunEditionState>(
      buildWhen: (previous, current) => previous.tasks != current.tasks || previous.step != current.step,
      builder: (context, state) {
        return state.step.value != null
            ? Row(
                children: [
                  Expanded(
                    child: (state.tasks.value?.length ?? 0) > 0
                        ? MultiSelectChipDisplay(
                            items: state.tasks.value?.map((task) => MultiSelectItem(task, task.text)).toList() ?? [],
                          )
                        : const Text("Sélectionnez des tâches"),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () => _selectTasks(context, state),
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
