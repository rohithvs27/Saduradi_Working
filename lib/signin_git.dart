import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saduradi_phone_signin/HomeView.dart';
import 'package:saduradi_phone_signin/crudscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseAuthException authException;

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPage extends StatefulWidget {
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
            color: Colors.white,
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
  final GlobalKey<FormState> _resetformKey = GlobalKey<FormState>();

  final TextEditingController _promotorNameController = TextEditingController();
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
                  child: Icon(Icons.person, size: 50, color: Colors.red[900])),
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
                keyboardType: TextInputType.text,
                controller: _promotorNameController,
                decoration: InputDecoration(
                  labelText: 'Promotor Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.red[900],
                  ),
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
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.red[900],
                  ),
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.red[900],
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
                obscureText: true,
              ),
              Center(
                child: FlatButton(
                    child: Text(
                      "Forgot Password/Reset Password",
                      style: TextStyle(color: Colors.red[900]),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: resetpasswordalert(),
                                actions: [
                                  FlatButton(
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(color: Colors.red[900]),
                                    ),
                                    onPressed: () {
                                      if (_resetformKey.currentState
                                          .validate()) {
                                        resetPassword(
                                            _emailController.text.trim());
                                      }
                                    },
                                  )
                                ],
                              ));
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: MaterialButton(
                  color: Colors.grey[200],
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  height: 50,
                  minWidth: 140,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.red[900],
                          width: 1,
                          style: BorderStyle.solid),
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

  Widget resetpasswordalert() {
    return Container(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Center(
              child: Column(
            children: <Widget>[
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _resetformKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Reset password',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter some text';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    bool admin;
    String empname;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ))
          .user;

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection(_promotorNameController.text.trim());
      collectionReference
          .doc('Users')
          .collection("usercollection")
          .doc(user.uid)
          .get()
          .then((docsnap) => {
                if (docsnap.exists)
                  {
                    admin = docsnap.data()['isAdmin'],
                    empname = docsnap.data()['name'],
                    print(empname),
                    prefs.setBool('admin', admin),
                    prefs.setString('uid', user.uid),
                    prefs.setString('empname', empname),
                    prefs.setString(
                        'promotorname', _promotorNameController.text.trim()),
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("${user.email} signed in"),
                    )),
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                _promotorNameController.text.trim(),
                                user.uid,
                                admin,
                                empname)))
                  }
                else
                  {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid Promotor Name/User ID"),
                    ))
                  }
              });

      /*Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  CrudScreen(_promotorNameController.text.trim(), user.uid)));
    */
    } catch (e) {
      authException = e;
      print(authException.message);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(authException.message),
      ));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please check you email for password reset link"),
      ));
      Navigator.pop(context);
    } catch (e) {
      authException = e;
      print(authException.message);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(authException.message),
      ));
    }
  }
}
