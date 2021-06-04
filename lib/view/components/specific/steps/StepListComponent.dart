import 'package:flutter/material.dart' hide Step, StepState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/steps/StepBloc.dart';
import 'package:gobz_app/data/blocs/steps/StepsBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Step.dart';
import 'package:gobz_app/data/repositories/StepRepository.dart';
import 'package:gobz_app/view/components/forms/steps/StepForm.dart';
import 'package:gobz_app/view/pages/FormPage.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/HoldMenu.dart';
import 'package:gobz_app/view/widgets/lists/GenericList.dart';
import 'package:gobz_app/view/widgets/lists/items/StepListItem.dart';

class StepListComponent extends StatelessWidget {
  final Chapter chapter;

  const StepListComponent({Key? key, required this.chapter}) : super(key: key);

  void _refreshSteps(BuildContext context) {
    context.read<StepsBloc>().add(StepsEvents.fetch());
  }

  void _refreshStep(BuildContext context) {
    context.read<StepBloc>().add(StepEvents.fetch());
  }

  void _createStep(BuildContext context) async {
    await Navigator.push(
      context,
      FormPage.route<Step>(
        NewStepForm(
          chapterId: chapter.id,
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Nouvelle étape",
      ),
    );

    _refreshStep(context);
  }

  void _editStep(BuildContext context, Step step) async {
    final Step? result = await Navigator.push(
      context,
      FormPage.route<Step>(
        EditStepForm(
          step: step,
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Edition de ${step.name}",
      ),
    );

    if (result != null) {
      _refreshStep(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StepsBloc>(
      create: (context) => StepsBloc(
        chapter: chapter,
        stepRepository: context.read<StepRepository>(),
        fetchOnStart: true,
      ),
      child: Scaffold(
        body: BlocHandler<StepsBloc, StepsState>.custom(
          mapEventToNotification: (state) {
            if (state.deletedStep != null) {
              return BlocNotification.success(
                "${state.deletedStep!.name} a été supprimé",
              ).copyWith(postAction: _refreshSteps);
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

              return GenericList<Step>(
                data: state.steps,
                itemBuilder: (context, step) => BlocProvider<StepBloc>(
                  create: (context) => StepBloc(context.read<StepRepository>(), step),
                  child: BlocBuilder<StepBloc, StepState>(
                      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                      builder: (context, state) {
                        if (state.isLoading) {
                          return Row(
                            children: [
                              CircularProgressIndicator(),
                              Container(width: 5),
                              Text("Chargement de ${state.step.name}..."),
                            ],
                          );
                        }

                        return HoldMenu<Function(Step)>(
                          onSelected: (action) => action?.call(step),
                          items: <PopupMenuEntry<Function(Step)>>[
                            PopupMenuItem<Function(Step)>(
                              value: (step) => _refreshStep(context),
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
                          child: StepListItem(step: step),
                        );
                      }),
                ),
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
