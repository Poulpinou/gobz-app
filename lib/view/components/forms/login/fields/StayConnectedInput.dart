part of '../LoginForm.dart';

class _StayConnectedInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.stayConnected != current.stayConnected || previous.localValuesLoaded != current.localValuesLoaded,
      builder: (context, state) => Row(
        children: [
          Checkbox(
            key: const Key('loginForm_stayConnected'),
            value: state.stayConnected,
            onChanged: (value) => context.read<LoginBloc>().add(LoginEvents.stayConnectedChanged(value ?? false)),
          ),
          const Text('Rester connecté?')
        ],
      ),
    );
  }
}
