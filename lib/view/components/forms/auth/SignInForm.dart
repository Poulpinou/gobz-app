import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gobz_app/data/blocs/auth/SignInBloc.dart';

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
          _SignInButton(),
        ],
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
          key: const Key('signInForm_usernameInput'),
          onChanged: (username) => context.read<SignInBloc>().add(SignInEvents.usernameChanged(username)),
          decoration: InputDecoration(
              labelText: 'Pseudo', errorText: state.username.invalid ? state.username.error?.message : null),
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
          key: const Key('signInForm_emailInput'),
          onChanged: (email) => context.read<SignInBloc>().add(SignInEvents.emailChanged(email)),
          decoration:
              InputDecoration(labelText: 'Email', errorText: state.email.invalid ? state.email.error?.message : null),
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
          key: const Key('signInForm_passwordInput'),
          onChanged: (password) => context.read<SignInBloc>().add(SignInEvents.passwordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            errorText: state.password.invalid ? state.password.error?.message : null,
          ),
        );
      },
    );
  }
}

class _PasswordRepeatInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.repeatPassword != current.repeatPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_passwordValidationInput'),
          onChanged: (password) => context.read<SignInBloc>().add(SignInEvents.passwordRepeatChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmation du mot de passe',
            errorText: state.repeatPassword.invalid ? state.repeatPassword.error?.message : null,
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
                key: const Key('signInForm_submit'),
                child: const Text('Connexion'),
                onPressed: state.status.isValidated
                    ? () => context.read<SignInBloc>().add(SignInEvents.signInSubmitted())
                    : null,
              );
      },
    );
  }
}
