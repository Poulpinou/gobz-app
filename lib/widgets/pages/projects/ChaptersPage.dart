import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ChaptersBloc.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';
import 'package:gobz_app/widgets/misc/CircularLoader.dart';
import 'package:gobz_app/widgets/pages/projects/parts/components/ChapterList.dart';

class ChaptersPage extends StatelessWidget {
  final Project project;

  const ChaptersPage({Key? key, required this.project}) : super(key: key);

  static Route route(Project project) {
    return MaterialPageRoute(builder: (_) => ChaptersPage(project: project));
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
                      onChapterClicked: (chapter) => print(chapter.name),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
