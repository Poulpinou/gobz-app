import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gobz_app/blocs/SignInBloc.dart';
import 'package:gobz_app/repositories/AuthRepository.dart';
import 'package:gobz_app/widgets/forms/auth/SignInForm.dart';

import 'LoginPage.dart';

class SignInPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création de compte"),
      ),
      body: BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(
          RepositoryProvider.of<AuthRepository>(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignInForm(),
                Container(height: 12),
                TextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        LoginPage.route(), (route) => false),
                    child: const Text("J'ai déjà un compte")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
