import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //controllers declearation
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          //Email Field
          TextField(
            controller: _email, //email controller decleared above
            enableSuggestions: false,
            autocorrect: false,
            keyboardType:
                TextInputType.emailAddress, // make keyboard to appear with @
            decoration: const InputDecoration(
              hintText: 'Enter your Email', //placeholder
            ),
          ),

          //Password Field
          TextField(
            controller: _password, //passeord controller declared above
            obscureText:
                true, //Make password appear in dots and not the actual text
            enableSuggestions: false, //text suggestions un enabled
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your Password', //Like placeholder in html
            ),
          ),

          //Regiser Button
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email is Alraedy in Use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'This is an Invalid Email Address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to Register',
                );
              }
            },
            child: const Text('Register'),
          ),

          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login Here'))
        ],
      ),
    );
  }
}
