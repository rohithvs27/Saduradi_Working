import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {
  final String uid;

  HomePage(this.uid);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: <Widget>[
                Builder(builder: (BuildContext context) {
                  return FlatButton(
                    child: const Text('Sign out'),
                    textColor: Theme.of(context).buttonColor,
                    onPressed: () async {
                      final User user = _auth.currentUser;
                      if (user == null) {
                        Scaffold.of(context).showSnackBar(const SnackBar(
                          content: Text('No one has signed in.'),
                        ));
                        return;
                      }
                      _signOut();
                      final String uid = user.uid;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(uid + ' has successfully signed out.'),
                      ));
                    },
                  );
                })
              ],
            ),
            body: Container(
              child: StreamBuilder(
                  stream: getUsersTripsStreamSnapshots(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text("Loading...");
                    return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            buildTripCard(
                                context, snapshot.data.documents[index]));
                  }),
            )));
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('data')
        .doc(uid)
        .collection('project')
        .snapshots();
  }

  void _signOut() async {
    await _auth.signOut();
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot projectname) {
    return Container(
        child: SingleChildScrollView(
            child: Card(
                child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Row(children: <Widget>[
            Text(
              projectname['project_Name'],
              style: new TextStyle(fontSize: 30.0),
            ),
            Spacer(),
          ]),
        )
      ]),
    ))));
  }
}
