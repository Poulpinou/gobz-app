import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/auth/SignInBloc.dart';
import 'package:gobz_app/data/repositories/AuthRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

part 'fields/EmailInput.dart';

part 'fields/PasswordInput.dart';

part 'fields/PasswordRepeatInput.dart';

part 'fields/UsernameInput.dart';

class SignInForm extends StatelessWidget {
  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signInForm_submit'),
                child: const Text('Création du compte'),
                onPressed: state.status.isValidated
                    ? () => context.read<SignInBloc>().add(SignInEvents.signInSubmitted())
                    : null,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        RepositoryProvider.of<AuthRepository>(context),
      ),
      child: BlocHandler<SignInBloc, SignInState>.simple(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(8)),
            _PasswordRepeatInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }
}
