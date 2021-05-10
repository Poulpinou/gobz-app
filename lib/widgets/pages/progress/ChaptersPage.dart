import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ChaptersBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:gobz_app/widgets/pages/progress/NewChapterPage.dart';
import 'package:gobz_app/widgets/pages/progress/parts/components/ChapterList.dart';

import 'ChapterPage.dart';

class ChaptersPage extends StatelessWidget {
  final Project project;

  const ChaptersPage({Key? key, required this.project}) : super(key: key);

  static Route route(Project project) {
    return MaterialPageRoute(builder: (_) => ChaptersPage(project: project));
  }

  void _createChapter(BuildContext context) async {
    final Chapter? chapter = await Navigator.push(context, NewChapterPage.route(project));

    if (chapter != null) {
      context.read<ChaptersBloc>().add(ChaptersEvents.fetch());

      Navigator.push(context, ChapterPage.route(chapter));
    }
  }

  void _clickChapter(BuildContext context, Chapter chapter) async {
    await Navigator.push(context, ChapterPage.route(chapter));

    context.read<ChaptersBloc>().add(ChaptersEvents.fetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final ChaptersBloc bloc = ChaptersBloc(
          project: project,
          chapterRepository: RepositoryProvider.of<ChapterRepository>(context),
        );

        bloc.add(ChaptersEvents.fetch());

        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chapitres"),
          actions: [
            PopupMenuButton<Function>(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.more_vert),
              ),
              onSelected: (function) => function(),
              itemBuilder: (context) => <PopupMenuEntry<Function>>[
                PopupMenuItem(
                  child: const Text("Actualiser"),
                  value: () => context.read<ChaptersBloc>().add(ChaptersEvents.fetch()),
                ),
              ],
            ),
          ],
        ),
        body: BlocHandler<ChaptersBloc, ChaptersState>.simple(
          child: Column(
            children: [
              BlocBuilder<ChaptersBloc, ChaptersState>(
                buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                builder: (context, state) {
                  if (state.isLoading) {
                    return Expanded(child: CircularLoader("Récupération des chapitres..."));
                  }

                  if (state.isErrored) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Impossible de récupérer les chapitres"),
                            ElevatedButton(
                                onPressed: () => context.read<ChaptersBloc>().add(ChaptersEvents.fetch()),
                                child: const Text("Réessayer"))
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.chapters.length == 0) {
                    return Expanded(
                      child: Center(
                        child: const Text("Il n'y a encore aucun chapitre dans le projet"),
                      ),
                    );
                  }

                  return Expanded(
                    child: ChapterList(
                      chapters: state.chapters,
                      onChapterClicked: (chapter) => _clickChapter(context, chapter),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<ChaptersBloc, ChaptersState>(
          builder: (context, state) => FloatingActionButton(
            onPressed: () => _createChapter(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
