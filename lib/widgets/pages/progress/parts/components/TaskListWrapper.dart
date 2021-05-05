part of 'StepList.dart';

class _TaskListWrapper extends StatelessWidget {
  final Step step;

  const _TaskListWrapper({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksBloc>(
      create: (context) {
        final TasksBloc bloc = TasksBloc(step: step, taskRepository: context.read<TaskRepository>());

        bloc.add(TasksEvents.fetch());

        return bloc;
      },
      child: BlocHandler<TasksBloc, TasksState>.simple(
        child: BlocBuilder<TasksBloc, TasksState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularLoader("Récupération des tâches..."));
            }

            if (state.isErrored) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Impossible de récupérer les tâches"),
                    ElevatedButton(
                        onPressed: () => context.read<TasksBloc>().add(TasksEvents.fetch()),
                        child: const Text("Réessayer"))
                  ],
                ),
              );
            }

            if (state.tasks.length == 0) {
              return Center(
                child: const Text("Il n'y a encore aucune tâche dans cette étape"),
              );
            }

            return TaskList(
              tasks: state.tasks,
            );
          },
        ),
      ),
    );
  }
}
