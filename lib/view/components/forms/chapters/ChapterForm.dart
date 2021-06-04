import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/chapters/ChapterEditionBloc.dart';
import 'package:gobz_app/data/models/Chapter.dart';
import 'package:gobz_app/data/models/enums/FormMode.dart';
import 'package:gobz_app/data/repositories/ChapterRepository.dart';
import 'package:gobz_app/view/components/forms/FormComponent.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

part 'fields/DescriptionField.dart';
part 'fields/NameField.dart';

class NewChapterForm extends _ChapterFormBase {
  final int projectId;

  NewChapterForm({
    required this.projectId,
    Function(Chapter chapter)? onValidate,
  }) : super(FormMode.CREATE, onValidate);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterEditionBloc>(
      create: (context) => ChapterEditionBloc.creation(context.read<ChapterRepository>()),
      child: super.build(context),
    );
  }

  @override
  ChapterEditionEvent get submissionEvent => ChapterEditionEvents.create(projectId);
}

class EditChapterForm extends _ChapterFormBase {
  final Chapter chapter;

  EditChapterForm({
    required this.chapter,
    Function(Chapter chapter)? onValidate,
  }) : super(FormMode.EDIT, onValidate);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChapterEditionBloc>(
      create: (context) => ChapterEditionBloc.edition(
        context.read<ChapterRepository>(),
        chapter,
      ),
      child: super.build(context),
    );
  }

  @override
  ChapterEditionEvent get submissionEvent => ChapterEditionEvents.update();
}

abstract class _ChapterFormBase extends StatelessWidget implements FormComponent<Chapter> {
  final FormMode formMode;
  final Function(Chapter chapter)? onValidate;

  const _ChapterFormBase(
    this.formMode,
    this.onValidate, {
    Key? key,
  }) : super(key: key);

  bool get isCreation => formMode == FormMode.CREATE;

  ChapterEditionEvent get submissionEvent;

  @override
  Widget build(BuildContext context) {
    return BlocHandler<ChapterEditionBloc, ChapterEditionState>.custom(
      mapEventToNotification: (state) {
        if (state.isSubmissionSuccess && state.chapter != null) {
          return BlocNotification.success(
            "${isCreation ? 'Création' : 'Sauvegarde'} de ${state.chapter!.name} réussie!",
          ).withPostAction((context) => onValidate?.call(state.chapter!));
        }
      },
      child: BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isSubmissionInProgress) {
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
              _NameField(initialValue: state.name.value),
              const Padding(padding: EdgeInsets.all(8)),
              _DescriptionField(initialValue: state.description.value),
              const Padding(padding: EdgeInsets.all(12)),
              BlocBuilder<ChapterEditionBloc, ChapterEditionState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) => ElevatedButton(
                  key: const Key("chapterForm_submit"),
                  onPressed:
                      state.status.isValidated ? () => context.read<ChapterEditionBloc>().add(submissionEvent) : null,
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
