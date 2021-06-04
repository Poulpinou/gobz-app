import 'package:flutter/material.dart' hide Step, StepState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/StepBloc.dart';
import 'package:gobz_app/blocs/StepsBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/repositories/StepRepository.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:gobz_app/widgets/misc/HoldMenu.dart';
import 'package:gobz_app/widgets/pages/progress/parts/components/StepList.dart';

import '../../EditStepPage.dart';
import '../../NewStepPage.dart';

class StepListWrapper extends StatelessWidget {
  final Chapter chapter;

  const StepListWrapper({Key? key, required this.chapter}) : super(key: key);

  void _refreshSteps(BuildContext context) {
    context.read<StepsBloc>().add(StepsEvents.fetch());
  }

  void _refreshStep(BuildContext context) {
    context.read<StepBloc>().add(StepEvents.fetch());
  }

  void _createStep(BuildContext context) async {
    await Navigator.push(context, NewStepPage.route(chapter));
    _refreshStep(context);
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
      _refreshStep(context);
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
          mapErrorToNotification: (state) {
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

              return StepList.builder(
                steps: state.steps,
                builder: (context, step) => BlocProvider<StepBloc>(
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
