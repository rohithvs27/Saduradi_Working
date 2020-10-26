import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseAuthException authException;
String promName;
String tempPassword = "password";

/// Entrypoint example for various sign-in flows with Firebase.
class CreateNewEmp extends StatefulWidget {
  final String promotorname;
  CreateNewEmp(this.promotorname);

  @override
  State<StatefulWidget> createState() => _CreateNewEmpState();
}

class _CreateNewEmpState extends State<CreateNewEmp> {
  @override
  void initState() {
    super.initState();
    promName = widget.promotorname;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: ListView(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _EmailPasswordForm(),
            ],
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
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
                  'Add Employee',
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
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(
                    Icons.person_pin,
                    color: Colors.red[900],
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
              ),
              /* SizedBox(
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
              */
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: MaterialButton(
                  color: Colors.grey[200],
                  child: Text(
                    "Create User",
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
                      _CreateNewNonAdminUser();
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

  void _CreateNewNonAdminUser() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: tempPassword,
      ))
          .user;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection(promName).doc("Users");
      documentReference
          .collection("usercollection")
          .doc(user.uid)
          .set({'name': _nameController.text.trim(), 'isAdmin': false});

      resetPassword(_emailController.text.trim());
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();

      //Navigator.pop(context);
    } catch (e) {
      authException = e;
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
        content: Text("Password reset link sent to $email"),
      ));
    } catch (e) {
      authException = e;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(authException.message),
      ));
    }
  }

  // Example code of how to sign in with email and password.

}
