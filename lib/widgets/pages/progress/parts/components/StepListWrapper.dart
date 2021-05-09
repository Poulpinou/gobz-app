part of '../../ChapterPage.dart';

class _StepListWrapper extends StatelessWidget {
  final Chapter chapter;

  const _StepListWrapper({Key? key, required this.chapter}) : super(key: key);

  void _refreshSteps(BuildContext context) {
    context.read<StepsBloc>().add(StepsEvents.fetch());
    context.read<ChapterBloc>().add(ChapterEvents.fetch());
  }

  void _createStep(BuildContext context) async {
    await Navigator.push(context, NewStepPage.route(chapter));
    _refreshSteps(context);
  }

  void _deleteStep(BuildContext context, Step step) async {
    final bool? isConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Supprimer ${step.name}?'),
              content: Text('Attention, cette action est définitive!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Oui'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Non'),
                ),
              ],
            ));

    if (isConfirmed != null && isConfirmed == true) {
      context.read<StepsBloc>().add(StepsEvents.deleteStep(step));
    }
  }

  void _editStep(BuildContext context, Step step) async {
    final Step? result = await Navigator.push(context, EditStepPage.route(step));
    if (result != null) {
      _refreshSteps(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepsBloc>(
      create: (context) {
        final StepsBloc bloc = StepsBloc(chapter: chapter, stepRepository: context.read<StepRepository>());

        bloc.add(StepsEvents.fetch());

        return bloc;
      },
      child: Scaffold(
        body: BlocHandler<StepsBloc, StepsState>.custom(
          mapErrorToNotification: (state) {
            if (state.deletedStep != null) {
              return BlocNotification.success("${state.deletedStep!.name} a été supprimé");
            }
          },
          child: BlocBuilder<StepsBloc, StepsState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return CircularLoader("Récupération des étapes...");
              }

              if (state.isErrored) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Impossible de récupérer les étapes"),
                      ElevatedButton(onPressed: () => _refreshSteps(context), child: const Text("Réessayer"))
                    ],
                  ),
                );
              }

              if (state.steps.length == 0) {
                return Center(
                  child: const Text("Il n'y a encore aucune étape dans ce chapitre"),
                );
              }

              return StepList(
                steps: state.steps,
                stepActions: <PopupMenuEntry<Function(Step)>>[
                  PopupMenuItem<Function(Step)>(
                    value: (step) => _refreshSteps(context),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.refresh),
                        Container(width: 4),
                        const Text("Actualiser"),
                      ],
                    ),
                  ),
                  PopupMenuItem<Function(Step)>(
                    value: (step) => _editStep(context, step),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.edit),
                        Container(width: 4),
                        const Text("Éditer"),
                      ],
                    ),
                  ),
                  PopupMenuItem<Function(Step)>(
                    value: (step) => _deleteStep(context, step),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.delete),
                        Container(width: 4),
                        const Text("Supprimer"),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<StepsBloc, StepsState>(
          builder: (context, state) => FloatingActionButton(
            onPressed: () => _createStep(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
