import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ReportScreen extends StatefulWidget {
  int total = 0;
  final String promotorName;
  ReportScreen(this.promotorName);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var name;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppbar(context, "Reports"),
            body: Stack(
              children: [
                Align(
                  child: getBookingAmount(),
                )
              ],
            )));
  }

  Widget getBookingPerson() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.5,
      child: FutureBuilder<QuerySnapshot>(
          future: firestore
              .collection(widget.promotorName)
              .doc("Users")
              .collection("usercollection")
              .get(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData)
              return const AlertDialog(
                backgroundColor: Colors.transparent,
                content: Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                ),
              );
            return new ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  name = snapshot.data.docs[index]['name'];
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text(
                        snapshot.data.docs[index]['name'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      );
                    }
                  } else if (snapshot.hasError) {
                    Text('no data');
                  }
                  return CircularProgressIndicator();
                });
          }),
    );
  }

  Widget getBookingAmount() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: FutureBuilder<QuerySnapshot>(
          future: firestore
              .collection(widget.promotorName)
              .doc("Projects")
              .collection("projectlist")
              .doc("REPORT")
              .collection("plots")
              .get(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData)
              return const AlertDialog(
                backgroundColor: Colors.transparent,
                content: Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                ),
              );
            return new ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  int value = int.parse(
                      snapshot.data.docs[index]['bookingamount'].toString());
                  widget.total = widget.total + value;
                  print(widget.total);
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: index + 1 == snapshot.data.docs.length
                        ? Text(widget.total.toString())
                        : Text("Loading"),
                  );
                });
          }),
    );
  }
}
