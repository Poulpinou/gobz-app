import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/ChapterEditionBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';

part 'fields/DescriptionField.dart';

part 'fields/NameField.dart';

class CreateChapterForm extends StatelessWidget {
  final Function(Chapter? chapter)? onCreated;

  const CreateChapterForm({Key? key, this.onCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocHandler<ChapterEditionBloc, ChapterEditionState>.simple(
      child: BlocListener<ChapterEditionBloc, ChapterEditionState>(
        listenWhen: (previous, current) => previous.chapter == null && current.chapter != null,
        listener: (context, state) => onCreated?.call(state.chapter),
        child: BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Création du chapitre..."),
                  Container(height: 10),
                  LinearProgressIndicator(),
                ],
              );
            }

            return Column(
              children: [
                _NameField(),
                const Padding(padding: EdgeInsets.all(8)),
                _DescriptionField(),
                const Padding(padding: EdgeInsets.all(12)),
                BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
                  buildWhen: (previous, current) => previous.status != current.status,
                  builder: (context, state) => ElevatedButton(
                      key: const Key("chapterForm_submit"),
                      onPressed: state.status.isValidated
                          ? () => context.read<ChapterEditionBloc>().add(ChapterEditionEvents.create())
                          : null,
                      child: const Text("Créer")),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
