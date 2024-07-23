import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

//Type "stl" to create a widget statefull(stf) or stateless
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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

          //Login Button
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  devtools.log("Invalid Credentials");
                } else {
                  devtools.log('SOMETHING ELSE HAPPENED');
                  devtools.log(e.code);
                }
              }
            },
            child: const Text('Login'),
          ),

          TextButton(
            onPressed: () {
              //Moving to the register view using the route created in the main function
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not registered yet? register here'),
          )
        ],
      ),
    );
  }
}
