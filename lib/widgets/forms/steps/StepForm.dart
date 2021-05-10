import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/StepEditionBloc.dart';
import 'package:gobz_app/models/Step.dart';
import 'package:gobz_app/widgets/misc/BlocHandler.dart';

part 'fields/DescriptionField.dart';
part 'fields/NameField.dart';

class StepForm extends StatelessWidget {
  final Step? step;
  final Function(Step)? onValidate;
  final bool isCreation;

  const StepForm({Key? key, Step? step, this.onValidate})
      : this.step = step,
        this.isCreation = step == null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocHandler<StepEditionBloc, StepEditionState>.custom(
      mapErrorToNotification: (state) {
        if (state.hasBeenUpdated && state.step != null) {
          return BlocNotification.success("${isCreation ? 'Création' : 'Sauvegarde'} de ${state.step!.name} réussie!")
              .copyWith(
            postAction: (context) => onValidate?.call(state.step!),
          );
        }
      },
      child: BlocBuilder<StepEditionBloc, StepEditionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${isCreation ? 'Création' : 'Sauvegarde'} de l'étape..."),
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
              BlocBuilder<StepEditionBloc, StepEditionState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) => ElevatedButton(
                  key: const Key("stepForm_submit"),
                  onPressed: state.status.isValidated
                      ? () => context.read<StepEditionBloc>().add(isCreation
                          ? StepEditionEvents.createFormSubmitted()
                          : StepEditionEvents.updateFormSubmitted())
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
