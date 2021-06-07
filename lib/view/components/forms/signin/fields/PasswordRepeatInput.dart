part of '../SignInForm.dart';

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
