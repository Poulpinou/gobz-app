import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/chapters/ChapterEditionBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/Project.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/view/components/forms/chapters/ChapterForm.dart';

class NewChapterPage extends StatelessWidget {
  final Project project;

  const NewChapterPage({Key? key, required this.project}) : super(key: key);

  static Route<Chapter> route(Project project) {
    return MaterialPageRoute<Chapter>(
        builder: (_) => NewChapterPage(
              project: project,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterEditionBloc>(
      create: (context) => ChapterEditionBloc(
        context.read<ChapterRepository>(),
        projectId: project.id,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nouveau chapitre"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: ChapterForm(
              onValidate: (chapter) => Navigator.pop(context, chapter),
            ),
          ),
        ),
      ),
    );
  }
}
