part of '../LoginForm.dart';

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
          previous.email != current.email || previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) {
        if (_controller.text != state.email.value) _controller.text = state.email.value;

        return TextField(
          controller: _controller,
          key: const Key('loginForm_emailInput'),
          onChanged: (email) => context.read<LoginBloc>().add(LoginEvents.emailChanged(email)),
          decoration:
              InputDecoration(labelText: 'Email', errorText: state.email.invalid ? state.email.error?.message : null),
        );
      },
    );
  }
}
