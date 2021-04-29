import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/LoginBloc.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/widgets/forms/LoginForm.dart';

import 'SignInPage.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          RepositoryProvider.of<AuthRepository>(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                LoginForm(),
                const Padding(padding: EdgeInsets.all(12)),
                TextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        SignInPage.route(), (route) => false),
                    child: const Text("Créer un compte")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
