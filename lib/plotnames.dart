import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';

Map<String, dynamic> docs;
bool booked;
Color available;
Color showinfo = Colors.black;

class PlotNames extends StatefulWidget {
  final String uid;
  final String doc_id;

  PlotNames(this.uid, this.doc_id);

  @override
  _PlotNamesState createState() => _PlotNamesState();
}

class _PlotNamesState extends State<PlotNames> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _buyernamecontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _brokernamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //final double containerheight = size.height * 0.12;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppbar(context, widget.doc_id.toString()),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          setState(() {
            addplotcount();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        color: Colors.grey[300],
        height: size.height,
        child: Column(children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: getProjectPlotsStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const AlertDialog(
                    backgroundColor: Colors.transparent,
                    content: Text(
                      "Loading...",
                      textAlign: TextAlign.center,
                    ),
                  );
                return new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      booked =
                          snapshot.data.documents[index].data()['isbooked'];
                      available =
                          snapshot.data.documents[index].data()['isbooked']
                              ? Colors.red
                              : Colors.green;
                      bool registrationComplete = !snapshot
                          .data.documents[index]
                          .data()['registrationComplete'];

                      return Container(
                          height: 80,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 9,
                            shadowColor: Colors.black,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: size.width * 0.7,
                                      child: ListTile(
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 2),
                                            shape: BoxShape.circle,
                                            // You can use like this way or like the below line
                                            //borderRadius: new BorderRadius.circular(30.0),
                                            color: Colors.amberAccent,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.documents[index]
                                                    .data()['plotname']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          booked
                                              ? snapshot.data.documents[index]
                                                  .data()['buyername']
                                              : "Available",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(booked
                                            ? snapshot.data.documents[index]
                                                .data()['buyerphonenumber']
                                            : snapshot.data.documents[index]
                                                .data()['area']),
                                        onTap: () {
                                          snapshot.data.documents[index]
                                                  .data()["isbooked"]
                                              ? showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    content:
                                                        _showbuyerinfoalert(
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data()),
                                                    actions: <Widget>[
                                                      registrationComplete
                                                          //button to confirm registration
                                                          ? FlatButton(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                              child: Text(
                                                                  'Submit'),
                                                              onPressed:
                                                                  () async {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (_) =>
                                                                        AlertDialog(
                                                                            title:
                                                                                Text("Registration Confirmation"),
                                                                            content: SingleChildScrollView(
                                                                              child: Text("Are you sure registration is complete?"),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              FlatButton(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                                ),
                                                                                color: Colors.green,
                                                                                child: Text("Yes"),
                                                                                onPressed: () {
                                                                                  var plot_docid = snapshot.data.documents[index].id;

                                                                                  DocumentReference documentReference = FirebaseFirestore.instance.collection('data').doc(widget.uid).collection("projects").doc(widget.doc_id).collection("plots").doc(plot_docid);
                                                                                  documentReference.update({
                                                                                    "registrationComplete": true
                                                                                  });
                                                                                  Navigator.of(context).pop();
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              )
                                                                            ]));
                                                              },
                                                            )
                                                          : Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                "Property Registered",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .red),
                                                              )),
                                                    ],
                                                  ),
                                                )
                                              : Container();
                                        },
                                      ),
                                    ),
                                    Container(
                                        width: size.width * 0.24,
                                        child: !registrationComplete
                                            ? Text(
                                                "Property Registered",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : FlatButton(
                                                color: available,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                                child: Text(
                                                  booked ? "Cancel" : "Book",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) => snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .data()[
                                                                      "isbooked"]
                                                                  .toString() ==
                                                              "false"
                                                          ? AlertDialog(
                                                              content:
                                                                  _updatePlotDetails(),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                  color: Colors
                                                                      .green,
                                                                  //button to save buyer info details to DB
                                                                  child: Text(
                                                                      'Submit'),
                                                                  onPressed:
                                                                      () async {
                                                                    if (_formKey
                                                                        .currentState
                                                                        .validate()) {
                                                                      _update_data(
                                                                          snapshot
                                                                              .data
                                                                              .documents[
                                                                                  index]
                                                                              .id,
                                                                          snapshot
                                                                              .data
                                                                              .documents[index]
                                                                              .data()["isbooked"]);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          : AlertDialog(
                                                              title: Text(
                                                                  "Cancel Booking"),
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Text(
                                                                    "Are you sure to cancel booking"),
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  ),
                                                                  color: Colors
                                                                      .red,
                                                                  child: Text(
                                                                      "Cancel Booking"),
                                                                  onPressed:
                                                                      () {
                                                                    _update_data(
                                                                        snapshot
                                                                            .data
                                                                            .documents[
                                                                                index]
                                                                            .id,
                                                                        snapshot
                                                                            .data
                                                                            .documents[index]
                                                                            .data()["isbooked"]);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                )
                                                              ],
                                                            ));
                                                },
                                              )),
                                  ],
                                )
                              ],
                            ),
                          ));
                    });
              },
            ),
          ),
        ]),
      ),
    ));
  }

  Widget _updatePlotDetails() {
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
                "Buyer Info",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _buyernamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Buyer Name',
                        prefixIcon: Icon(Icons.person_add),
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
                      keyboardType: TextInputType.phone,
                      controller: _phonenumbercontroller,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (String value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value.isEmpty || !regExp.hasMatch(value))
                          return 'Please enter valid phone';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _brokernamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Broker Name',
                        prefixIcon: Icon(Icons.person_add),
                      ),
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  _update_data(String plot_docid, bool booked) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('data')
        .doc(widget.uid)
        .collection("projects")
        .doc(widget.doc_id)
        .collection("plots")
        .doc(plot_docid);
    !booked
        ? documentReference.update({
            "isbooked": true,
            "buyername": _buyernamecontroller.text.trim(),
            "buyerphonenumber": _phonenumbercontroller.text.trim(),
            "brokername": _brokernamecontroller.text.length > 0
                ? _brokernamecontroller.text.trim()
                : null,
            "bookingdate": DateTime.now(),
          })
        : documentReference.update({
            "isbooked": false,
            "buyername": null,
            "buyerphonenumber": null,
            "brokername": null,
            "bookingdate": null
          });
    _phonenumbercontroller.clear();
    _buyernamecontroller.clear();
    _brokernamecontroller.clear();
  }

  Stream<QuerySnapshot> getProjectPlotsStreamSnapshots(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('data')
        .doc(widget.uid)
        .collection("projects")
        .doc(widget.doc_id)
        .collection("plots")
        .orderBy("plotname", descending: false)
        .snapshots();
  }

  Widget _showbuyerinfoalert(var buyerinfo) {
    print(DateTime.now());
    var date = DateTime.fromMillisecondsSinceEpoch(
        buyerinfo['bookingdate'].millisecondsSinceEpoch);
    DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return Container(
        width: double.maxFinite,
        child: ListView(shrinkWrap: true, padding: EdgeInsets.only(top: 10),
            //scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  child: Center(
                    child: Text(
                      "Verify Registration",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      Icon(Icons.home),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.all(20),
                        child: Text(
                          buyerinfo["plotname"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              color: showinfo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      Icon(Icons.aspect_ratio),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.all(20),
                        child: Text(
                          buyerinfo["area"] + " " + "sq.ft",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              color: showinfo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      Icon(Icons.face),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.all(20),
                        child: Text(
                          buyerinfo["buyername"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              color: showinfo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      Icon(Icons.phone),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.all(20),
                        child: Text(
                          buyerinfo["buyerphonenumber"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              color: showinfo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        //padding: const EdgeInsets.all(20),
                        child: Text(
                          formatter.format(date),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              color: showinfo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ])
            ]));
  }

  addplotcount() {
    showDialog(
        context: context, builder: (_) => AlertDialog(content: _addplots()));
  }

  Widget _addplots() {
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
                "Buyer Info",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _buyernamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Buyer Name',
                        prefixIcon: Icon(Icons.person_add),
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
                      keyboardType: TextInputType.phone,
                      controller: _phonenumbercontroller,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (String value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value.isEmpty || !regExp.hasMatch(value))
                          return 'Please enter valid phone';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _brokernamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Broker Name',
                        prefixIcon: Icon(Icons.person_add),
                      ),
                    )
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _buyernamecontroller.dispose();
    _phonenumbercontroller.dispose();
    super.dispose();
  }
}
