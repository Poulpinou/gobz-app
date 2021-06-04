part of '../SignInForm.dart';

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