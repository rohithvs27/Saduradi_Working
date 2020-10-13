import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signin_git.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Widget customAppbar(context, name) {
  void _signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => SignInPage()),
        (route) => false);
  }

  return AppBar(
    centerTitle: true,
    backgroundColor: Color(0xff03dac6),
    title: Text(
      name.toString(),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.headline4,
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal),
    ),
    actions: <Widget>[
      Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.red,
            onPressed: () async {
              final User user = _auth.currentUser;
              if (user == null) {
                Scaffold.of(context).showSnackBar(const SnackBar(
                  content: Text('No one has signed in.'),
                ));
                return;
              } else {
                _signOut();
              }
              final String uid = user.uid;
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(uid + ' has successfully signed out.'),
              ));
            },
          ),
        );
      })
    ],
  );
}
