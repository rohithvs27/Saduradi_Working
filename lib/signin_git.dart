import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/HomeView.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseAuthException authException;

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPage extends StatefulWidget {
  /// The page title.
  final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: Card(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _EmailPasswordForm(),
              ],
            ),
          ),
        );
      }),
    ));
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 90,
              ),
              Center(
                  child:
                      Icon(Icons.person, size: 50, color: Colors.blueAccent)),
              SizedBox(
                height: 30,
              ),
              Container(
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: MaterialButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                  height: 50,
                  minWidth: 140,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ))
          .user;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', user.uid);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("${user.email} signed in"),
      ));
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => MyHomePage(user.uid)));
    } catch (e) {
      authException = e;
      print(authException.message);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(authException.message),
      ));
    }
  }
}
