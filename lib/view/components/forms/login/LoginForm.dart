import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/auth/LoginBloc.dart';
import 'package:gobz_app/data/repositories/AuthRepository.dart';
import 'package:gobz_app/view/widgets/generic/BlocHandler.dart';

part 'fields/EmailInput.dart';
part 'fields/PasswordInput.dart';
part 'fields/StayConnectedInput.dart';

class LoginForm extends StatelessWidget {
  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_submit'),
                child: const Text('Connexion'),
                onPressed:
                    state.status.isValidated ? () => context.read<LoginBloc>().add(LoginEvents.loginSubmitted()) : null,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        RepositoryProvider.of<AuthRepository>(context),
      ),
      child: BlocHandler<LoginBloc, LoginState>.simple(
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (!state.localValuesLoaded) {
              context.read<LoginBloc>().add(LoginEvents.loadLocalValues());
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EmailInput(),
                const Padding(padding: EdgeInsets.all(8)),
                _PasswordInput(),
                const Padding(padding: EdgeInsets.all(8)),
                _StayConnectedInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _buildLoginButton(context),
              ],
            );
          },
        ),
      ),
    );
  }
}
