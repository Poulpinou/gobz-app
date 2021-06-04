part of '../SignInForm.dart';

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