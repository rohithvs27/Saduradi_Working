import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';

class CrudScreen extends StatefulWidget {
  final String uid;
  final String promotorName;
  CrudScreen(this.promotorName, this.uid);

  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  var data;
  Map<String, dynamic> data1 = {
    "plotname": 1,
    "area": "1234",
    "isbooked": false,
    "registrationComplete": false
  };
  String docid = "Madurai";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context, widget.promotorName),
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              children: [
                RaisedButton(
                  child: Text("AddData"),
                  onPressed: () {
                    CollectionReference collectionReference = FirebaseFirestore
                        .instance
                        .collection(widget.promotorName);
                    collectionReference
                        .doc('Users')
                        .collection("usercollection")
                        .doc(widget.uid)
                        .get()
                        .then((user) => {
                              if (user.exists) {print(user.data()['isAdmin'])}
                            });
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                RaisedButton(
                    child: Text("FetchData"),
                    onPressed: () async {
                      print("########");
                      CollectionReference collectionReference =
                          FirebaseFirestore.instance
                              .collection('data')
                              .doc(widget.uid)
                              .collection("projects")
                              .doc(docid)
                              .collection("plots");
                      collectionReference.snapshots().listen((snapshot) {
                        var data;
                        setState(() {
                          data = snapshot.docs[0].data();
                          print(data);
                        });
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
