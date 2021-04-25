import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/blocs/SignInBloc.dart';

import 'inputs/EmailInput.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("La création du compte a échoué")),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _SignInButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<SignInBloc>().add(SignInUsernameChanged(username)),
          decoration: InputDecoration(
              labelText: 'Pseudo',
              errorText: state.username.invalid ? "Pseudo invalide" : null),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<SignInBloc>().add(SignInEmailChanged(email)),
          decoration: InputDecoration(
              labelText: 'Email',
              errorText: state.email.invalid
                  ? EmailInput.getMessageFromError(state.email.error!)
                  : null),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignInBloc>().add(SignInPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            errorText: state.password.invalid ? "Mot de passe invalide" : null,
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signInForm_continue_raisedButton'),
                child: const Text('Connexion'),
                onPressed: state.status.isValidated
                    ? () =>
                        context.read<SignInBloc>().add(const SignInSubmitted())
                    : null,
              );
      },
    );
  }
}
