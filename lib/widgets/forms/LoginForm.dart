import 'package:formz/formz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/LoginBloc.dart';
import 'package:gobz_app/widgets/forms/inputs/EmailInput.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Echec de l'authentification")),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (!state.localValuesLoaded) {
            context.read<LoginBloc>().add(LoadLocalValues());
          }

          return Align(
            alignment: const Alignment(0, -1 / 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EmailInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _PasswordInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _StayConnectedInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _LoginButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmailInput extends StatefulWidget {
  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        if (_controller.text != state.email.value)
          _controller.text = state.email.value;

        return TextField(
          controller: _controller,
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
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

class _PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        if (_controller.text != state.password.value)
          _controller.text = state.password.value;

        return TextField(
          controller: _controller,
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
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

class _StayConnectedInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.stayConnected != current.stayConnected ||
          previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) => Row(
        children: [
          Checkbox(
            key: const Key('loginForm_stayConnected_checkbox'),
            value: state.stayConnected,
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(StayConnectedChanged(value ?? false)),
          ),
          const Text('Rester connecté?')
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Connexion'),
                onPressed: state.status.isValidated
                    ? () =>
                        context.read<LoginBloc>().add(const LoginSubmitted())
                    : null,
              );
      },
    );
  }
}
