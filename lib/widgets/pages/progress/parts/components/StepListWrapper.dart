part of '../../ChapterPage.dart';

class _StepListWrapper extends StatelessWidget {
  final Chapter chapter;

  const _StepListWrapper({Key? key, required this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepsBloc>(
      create: (context) {
        final StepsBloc bloc = StepsBloc(chapter: chapter, stepRepository: context.read<StepRepository>());

        bloc.add(StepsEvents.fetch());

        return bloc;
      },
      child: BlocHandler<StepsBloc, StepsState>.simple(
        child: BlocBuilder<StepsBloc, StepsState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Expanded(child: CircularLoader("Récupération des étapes..."));
            }

            if (state.isErrored) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Impossible de récupérer les étapes"),
                      ElevatedButton(
                          onPressed: () => context.read<StepsBloc>().add(StepsEvents.fetch()),
                          child: const Text("Réessayer"))
                    ],
                  ),
                ),
              );
            }

            if (state.steps.length == 0) {
              return Expanded(
                child: Center(
                  child: const Text("Il n'y a encore aucune étape dans ce chapitre"),
                ),
              );
            }

            return Expanded(
              child: StepList(
                steps: state.steps,
              ),
            );
          },
        ),
      ),
    );
  }
}
