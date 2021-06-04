part of '../LoginForm.dart';

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
          previous.password != current.password || previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        if (_controller.text != state.password.value) _controller.text = state.password.value;

        return TextField(
          controller: _controller,
          key: const Key('loginForm_passwordInput'),
          onChanged: (password) => context.read<LoginBloc>().add(LoginEvents.passwordChanged(password)),
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
