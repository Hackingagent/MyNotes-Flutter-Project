import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  await showErrorDialog(
                    context,
                    'User Not Found',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}', //putting a variable inside a string inside ""
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),

          TextButton(
            onPressed: () {
              //Moving to the register view using the route created in the main function
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? register here'),
          )
        ],
      ),
    );
  }
}
