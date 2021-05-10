import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/ChapterEditionBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/repositories/ChapterRepository.dart';
import 'package:gobz_app/widgets/forms/chapters/ChapterForm.dart';

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
