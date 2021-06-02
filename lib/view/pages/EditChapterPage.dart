import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/data/blocs/chapters/ChapterEditionBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/view/components/forms/chapters/ChapterForm.dart';

class EditChapterPage extends StatelessWidget {
  final Chapter chapter;

  const EditChapterPage({Key? key, required this.chapter}) : super(key: key);

  static Route<Chapter> route(Chapter chapter) {
    return MaterialPageRoute<Chapter>(
        builder: (_) => EditChapterPage(
              chapter: chapter,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterEditionBloc>(
      create: (context) => ChapterEditionBloc(
        context.read<ChapterRepository>(),
        chapter: chapter,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edition de ${chapter.name}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: ChapterForm(
              chapter: chapter,
              onValidate: (chapter) => Navigator.pop(context, chapter),
            ),
          ),
        ),
      ),
    );
  }
}
