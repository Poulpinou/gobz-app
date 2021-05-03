import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/ChapterEditionBloc.dart';
import 'package:gobz_app/models/Chapter.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';

part 'fields/DescriptionField.dart';

part 'fields/NameField.dart';

class ChapterForm extends StatelessWidget {
  final Chapter? chapter;
  final Function(Chapter)? onValidate;
  final bool isCreation;

  const ChapterForm({Key? key, Chapter? chapter, this.onValidate})
      : this.chapter = chapter,
        this.isCreation = chapter == null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocHandler<ChapterEditionBloc, ChapterEditionState>.custom(
      mapErrorToNotification: (state) {
        if (state.hasBeenUpdated && state.chapter != null) {
          return BlocNotification.success(
                  "${isCreation ? 'Création' : 'Sauvegarde'} de ${state.chapter!.name} réussie!")
              .copyWith(
            postAction: (context) => Navigator.pop(context, state.chapter),
          );
        }
      },
      child: BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${isCreation ? 'Création' : 'Sauvegarde'} du chapitre..."),
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
                      ? () => context.read<ChapterEditionBloc>().add(isCreation
                          ? ChapterEditionEvents.createFormSubmitted()
                          : ChapterEditionEvents.updateFormSubmitted())
                      : null,
                  child: Text(isCreation ? 'Créer' : 'Sauvegarder'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
