import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/chapters/ChapterBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/view/components/forms/chapters/ChapterForm.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';
import 'package:gobz_app/view/widgets/generic/CircularLoader.dart';
import 'package:gobz_app/view/widgets/generic/FetchFailure.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../components/specific/steps/StepListComponent.dart';
import 'generic/FormPage.dart';

class ChapterPage extends StatelessWidget {
  final int chapterId;

  const ChapterPage({Key? key, required this.chapterId}) : super(key: key);

  static Route route(int chapterId) {
    return MaterialPageRoute<void>(builder: (_) => ChapterPage(chapterId: chapterId));
  }

  // Actions
  void _refreshChapter(BuildContext context) {
    context.read<ChapterBloc>().add(ChapterEvents.fetch());
  }

  void _deleteChapter(BuildContext context, Chapter chapter) async {
    final bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer ${chapter.name}?'),
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
      ),
    );

    if (isConfirmed != null && isConfirmed == true) {
      context.read<ChapterBloc>().add(ChapterEvents.delete());
    }
  }

  void _editChapter(BuildContext context, Chapter chapter) async {
    final Chapter? result = await Navigator.push(
      context,
      FormPage.route<Chapter>(
        EditChapterForm(
          chapter: chapter,
          onValidate: (result) => Navigator.pop(context, result),
        ),
        title: "Edition de ${chapter.name}",
      ),
    );

    if (result != null) {
      context.read<ChapterBloc>().add(ChapterEvents.fetch());
    }
  }

  // Build Parts
  AppBar _buildAppBar(BuildContext context, Chapter? chapter) {
    return AppBar(
      title: Text(chapter?.name ?? "Chargement du chapitre..."),
      actions: chapter != null
          ? [
              PopupMenuButton<Function>(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.more_vert),
                ),
                onSelected: (function) => function(),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Function>>[
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.refresh),
                        Container(width: 4),
                        const Text("Actualiser"),
                      ],
                    ),
                    value: () => _refreshChapter(context),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.edit),
                        Container(width: 4),
                        const Text("Éditer"),
                      ],
                    ),
                    value: () => _editChapter(context, chapter),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.delete),
                        Container(width: 4),
                        const Text("Supprimer"),
                      ],
                    ),
                    value: () => _deleteChapter(context, chapter),
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocHandler<ChapterBloc, ChapterState>.custom(
      mapEventToNotification: (state) {
        if (state.hasBeenDeleted) {
          return BlocNotification.success("${state.chapter?.name ?? "Le chapitre"} a été supprimé")
              .copyWith(postAction: (context) => Navigator.pop(context, null));
        }
      },
      child: child,
    );
  }

  Widget _buildChapterHeader(BuildContext context, ChapterState state) {
    final double completion = state.chapter?.completion ?? 0;

    return BlocBuilder<ChapterBloc, ChapterState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) => ColoredBox(
          color: Theme.of(context).secondaryHeaderColor,
          child: Column(
            children: [
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 20.0,
                animation: true,
                animationDuration: 600,
                percent: completion,
                center: Text(completion < 1 ? "${(completion * 100).toStringAsFixed(1)}%" : "OK"),
                progressColor: Theme.of(context).colorScheme.secondary,
                linearStrokeCap: LinearStrokeCap.butt,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.chapter?.description ?? "Chargement en cours...",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildBody(BuildContext context, ChapterState state) {
    if (state.isErrored) {
      return FetchFailure(
        message: "Le chargement du projet a échoué",
        error: state.error,
        retryFunction: () => _refreshChapter(context),
      );
    }

    if (!state.hasBeenFetched) {
      return CircularLoader("Chargement du projet...");
    }

    return StepListComponent(chapter: state.chapter!);
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterBloc>(
      create: (context) => ChapterBloc(
        chapterRepository: context.read<ChapterRepository>(),
        chapterId: chapterId,
        fetchOnStart: true,
      ),
      child: BlocBuilder<ChapterBloc, ChapterState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) => Scaffold(
          appBar: _buildAppBar(context, state.data),
          body: _buildHandler(
            child: Column(
              children: [
                _buildChapterHeader(context, state),
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
