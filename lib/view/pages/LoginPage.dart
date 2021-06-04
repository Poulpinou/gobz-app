import 'package:flutter/material.dart';
import 'package:gobz_app/view/components/forms/login/LoginForm.dart';

import 'SignInPage.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LoginForm(),
              const Padding(padding: EdgeInsets.all(12)),
              TextButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(SignInPage.route(), (route) => false),
                  child: const Text("Créer un compte")),
            ],
          ),
        ),
      ),
    );
  }
}
