import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ChapterBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'EditChapterPage.dart';
import 'parts/wrappers/StepListWrapper.dart';

class ChapterPage extends StatelessWidget {
  final Chapter chapter;

  const ChapterPage({Key? key, required this.chapter}) : super(key: key);

  static Route route(Chapter chapter) {
    return MaterialPageRoute<void>(builder: (_) => ChapterPage(chapter: chapter));
  }

  // Actions
  void _refreshChapter(BuildContext context) {
    context.read<ChapterBloc>().add(ChapterEvents.fetch());
  }

  void _deleteChapter(BuildContext context) async {
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
            ));

    if (isConfirmed != null && isConfirmed == true) {
      context.read<ChapterBloc>().add(ChapterEvents.delete());
    }
  }

  void _editChapter(BuildContext context) async {
    final Chapter? chapter = await Navigator.push(context, EditChapterPage.route(this.chapter));

    if (chapter != null) {
      context.read<ChapterBloc>().add(ChapterEvents.fetch());
    }
  }

  // Build Parts
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ChapterBloc, ChapterState>(
          buildWhen: (previous, current) => previous.chapter.name != current.chapter.name,
          builder: (context, state) => Text(state.chapter.name)),
      actions: [
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
              value: () => _editChapter(context),
            ),
            PopupMenuItem(
              child: Row(
                children: <Widget>[
                  const Icon(Icons.delete),
                  Container(width: 4),
                  const Text("Supprimer"),
                ],
              ),
              value: () => _deleteChapter(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHandler({required Widget child}) {
    return BlocHandler<ChapterBloc, ChapterState>.custom(
      mapErrorToNotification: (state) {
        if (state.chapterDeleted) {
          return BlocNotification.success("${state.chapter.name} a été supprimé")
              .copyWith(postAction: (context) => Navigator.pop(context, null));
        }
      },
      child: child,
    );
  }

  Widget _buildChapterHeader(BuildContext context, ChapterState state) {
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
              percent: state.chapter.completion!,
              center: Text(
                  state.chapter.completion! < 1 ? "${(state.chapter.completion! * 100).toStringAsFixed(1)}%" : "OK"),
              progressColor: Theme.of(context).colorScheme.secondary,
              linearStrokeCap: LinearStrokeCap.butt,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.chapter.description,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterBloc>(
      create: (context) => ChapterBloc(
        context.read<ChapterRepository>(),
        chapter,
        fetchOnStart: true,
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildHandler(
          child: BlocBuilder<ChapterBloc, ChapterState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) => Column(
              children: [
                _buildChapterHeader(context, state),
                Expanded(
                  child: StepListWrapper(chapter: state.chapter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
