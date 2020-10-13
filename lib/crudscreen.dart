import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudScreen extends StatefulWidget {
  String uid;
  CrudScreen(this.uid);
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
        body: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              children: [
                RaisedButton(
                  child: Text("AddData"),
                  onPressed: () {
                    CollectionReference collectionReference =
                        FirebaseFirestore.instance.collection('data');
                    collectionReference
                        .doc(widget.uid)
                        .collection("projects")
                        .doc("Salem")
                        .collection("plots")
                        .add(data1);
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
