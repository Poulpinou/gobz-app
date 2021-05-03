import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ChapterEditionBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/models/Project.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/widgets/forms/chapters/ChapterForm.dart';

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
        project.id,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nouveau chapitre"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: CreateChapterForm(
              onCreated: (chapter) => Navigator.pop(context, chapter),
            ),
          ),
        ),
      ),
    );
  }
}
