part of '../SignInForm.dart';

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