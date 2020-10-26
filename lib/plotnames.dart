import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/widgets/showbuyerinfoalert.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';

bool booked;
Color available;
Color customcolor = Colors.white;

class PlotNames extends StatefulWidget {
  final String promotorName;
  final String uid;
  final String doc_id;
  final bool admin;
  final String empname;

  PlotNames(this.promotorName, this.uid, this.doc_id, this.admin, this.empname);

  @override
  _PlotNamesState createState() => _PlotNamesState();
}

class _PlotNamesState extends State<PlotNames> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _buyernamecontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _brokernamecontroller = TextEditingController();
  final _addplotscontroller = TextEditingController();
  final _areainputcontroller = TextEditingController();
  final _directionFacingcontroller = TextEditingController();
  final _editareacontroller = TextEditingController();
  final _bookingAmountcontroller = TextEditingController();

  int range = 1;
  int doclength;
  String area = "1000";
  String editarea;
  String editdireaction;
  var directionVal = "NW";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //final double containerheight = size.height * 0.12;
    return SafeArea(
        child: widget.admin
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: customAppbar(context, widget.doc_id.toString()),
                floatingActionButton: FloatingActionButton(
                  tooltip: "Add Plots",
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[900],
                  onPressed: () {
                    setState(() {
                      _addplotcount();
                    });
                  },
                  child: Icon(Icons.add),
                ),
                body: Container(
                  color: Colors.white,
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
                          return new GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                booked = snapshot.data.documents[index]
                                    .data()['isbooked'];
                                available = snapshot.data.documents[index]
                                        .data()['isbooked']
                                    ? Colors.redAccent[200]
                                    : Colors.green[800];
                                bool registrationComplete = !snapshot
                                    .data.documents[index]
                                    .data()['registrationComplete'];

                                return Container(
                                    child: Card(
                                  color: registrationComplete
                                      ? available
                                      : Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: ListTile(
                                          contentPadding:
                                              EdgeInsets.only(top: 3, left: 3),
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: customcolor,
                                              border: Border.all(width: 1),
                                              shape: BoxShape.circle,
                                              // You can use like this way or like the below line
                                              //borderRadius: new BorderRadius.circular(30.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color:
                                                          registrationComplete
                                                              ? available
                                                              : Colors
                                                                  .grey[400]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                              booked
                                                  ? snapshot
                                                      .data.documents[index]
                                                      .data()['buyername']
                                                  : "Available",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: customcolor)),
                                          subtitle: Text(
                                              booked
                                                  ? snapshot
                                                          .data.documents[index]
                                                          .data()[
                                                      'buyerphonenumber']
                                                  : "${snapshot.data.documents[index].data()['directionFacing']} - ${snapshot.data.documents[index].data()['area']} sq.ft ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: customcolor)),
                                          onTap: () {
                                            snapshot.data.documents[index]
                                                    .data()["isbooked"]
                                                ? showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      content:
                                                          showbuyerinfoalert(
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
                                                                color: Colors
                                                                    .green,
                                                                child: Text(
                                                                    'Complete Registration'),
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (_) =>
                                                                          AlertDialog(
                                                                              title: Text("Registration Confirmation"),
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

                                                                                    DocumentReference documentReference = FirebaseFirestore.instance.collection(widget.promotorName).doc("Projects").collection("projectlist").doc(widget.doc_id).collection("plots").doc(plot_docid);
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
                                                                        .all(
                                                                            20),
                                                                child: Text(
                                                                  "Registration Completed",
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
                                                : editplotdetails(
                                                    snapshot
                                                        .data.documents[index]
                                                        .data(),
                                                    snapshot.data
                                                        .documents[index].id);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                          width: size.width * 0.24,
                                          child: !registrationComplete
                                              ? Text(
                                                  "Property Registered",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : RaisedButton(
                                                  color: Colors.white,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                  child: Text(
                                                    booked ? "Cancel" : "Book",
                                                    style: TextStyle(
                                                        color: available,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                                actions: <
                                                                    Widget>[
                                                                  OutlineButton(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),

                                                                    //button to save buyer info details to DB
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors.red[
                                                                              900],
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  OutlineButton(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),

                                                                    //button to save buyer info details to DB
                                                                    child: Text(
                                                                      'Submit',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .green,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        _update_data(
                                                                            snapshot.data.documents[index].id,
                                                                            snapshot.data.documents[index].data()["isbooked"]);
                                                                        Navigator.of(context)
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
                                                                actions: <
                                                                    Widget>[
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
                                                ))
                                    ],
                                  ),
                                ));
                              });
                        },
                      ),
                    ),
                  ]),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: customAppbar(context, widget.doc_id.toString()),
                body: Container(
                  color: Colors.white,
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
                          return new GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                booked = snapshot.data.documents[index]
                                    .data()['isbooked'];
                                available = snapshot.data.documents[index]
                                        .data()['isbooked']
                                    ? Colors.redAccent[200]
                                    : Colors.green[800];
                                bool registrationComplete = !snapshot
                                    .data.documents[index]
                                    .data()['registrationComplete'];

                                return Container(
                                    child: Card(
                                  color: registrationComplete
                                      ? available
                                      : Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: ListTile(
                                          contentPadding:
                                              EdgeInsets.only(top: 3, left: 3),
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: customcolor,
                                              border: Border.all(width: 1),
                                              shape: BoxShape.circle,
                                              // You can use like this way or like the below line
                                              //borderRadius: new BorderRadius.circular(30.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color:
                                                          registrationComplete
                                                              ? available
                                                              : Colors
                                                                  .grey[400]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                              booked
                                                  ? snapshot
                                                      .data.documents[index]
                                                      .data()['buyername']
                                                  : "Available",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: customcolor)),
                                          subtitle: Text(
                                              booked
                                                  ? snapshot
                                                          .data.documents[index]
                                                          .data()[
                                                      'buyerphonenumber']
                                                  : "${snapshot.data.documents[index].data()['directionFacing']} - ${snapshot.data.documents[index].data()['area']} sq.ft ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: customcolor)),
                                          onTap: () {
                                            snapshot.data.documents[index]
                                                    .data()["isbooked"]
                                                ? showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      content:
                                                          showbuyerinfoalert(
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
                                                                color: Colors
                                                                    .green,
                                                                child: Text(
                                                                    'Complete Registration'),
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (_) =>
                                                                          AlertDialog(
                                                                              title: Text("Registration Confirmation"),
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

                                                                                    DocumentReference documentReference = FirebaseFirestore.instance.collection(widget.promotorName).doc("Projects").collection("projectlist").doc(widget.doc_id).collection("plots").doc(plot_docid);
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
                                                                        .all(
                                                                            20),
                                                                child: Text(
                                                                  "Registration Completed",
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
                                                : 0;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                          width: size.width * 0.24,
                                          child: !registrationComplete
                                              ? Text(
                                                  "Property Registered",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : RaisedButton(
                                                  color: Colors.white,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                  child: Text(
                                                    booked ? "Cancel" : "Book",
                                                    style: TextStyle(
                                                        color: available,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                                actions: <
                                                                    Widget>[
                                                                  OutlineButton(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),

                                                                    //button to save buyer info details to DB
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors.red[
                                                                              900],
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  OutlineButton(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18.0),
                                                                    ),

                                                                    //button to save buyer info details to DB
                                                                    child: Text(
                                                                      'Submit',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .green,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        _update_data(
                                                                            snapshot.data.documents[index].id,
                                                                            snapshot.data.documents[index].data()["isbooked"]);
                                                                        Navigator.of(context)
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
                                                                actions: <
                                                                    Widget>[
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
                                                ))
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

  Stream<QuerySnapshot> getProjectPlotsStreamSnapshots(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection(widget.promotorName)
        .doc("Projects")
        .collection("projectlist")
        .doc(widget.doc_id)
        .collection("plots")
        .orderBy("plotname", descending: false)
        .snapshots();
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
                      keyboardType: TextInputType.number,
                      controller: _bookingAmountcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Booking Amount',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter booking amount';
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
        .collection(widget.promotorName)
        .doc("Projects")
        .collection("projectlist")
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
            "bookingamount": _bookingAmountcontroller.text.trim(),
            "bookingdate": DateTime.now(),
            "bookingperson": widget.empname
          })
        : documentReference.update({
            "isbooked": false,
            "buyername": null,
            "buyerphonenumber": null,
            "brokername": null,
            "bookingdate": null,
            "bookingamount": null,
            "bookingperson": null
          });
    _phonenumbercontroller.clear();
    _buyernamecontroller.clear();
    _brokernamecontroller.clear();
  }

  _addplotcount() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: _addplots(),
              actions: <Widget>[
                OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),

                  //button to save buyer info details to DB
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red[900], fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.green,
                    //button to save buyer info details to DB
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      print("onPressed");
                      if (_formKey.currentState.validate()) {
                        CollectionReference collectionReference =
                            FirebaseFirestore.instance
                                .collection(widget.promotorName)
                                .doc("Projects")
                                .collection("projectlist")
                                .doc(widget.doc_id)
                                .collection("plots");
                        var getdoclength = await collectionReference
                            .get()
                            .then((value) => value.size);
                        doclength = getdoclength.toInt();
                        range = int.parse(_addplotscontroller.text.trim());
                        for (int i = 1 + doclength;
                            i <= range + doclength;
                            i++) {
                          collectionReference.add({
                            "plotname": i,
                            "area": _areainputcontroller.text.trim(),
                            "directionFacing": directionVal,
                            "isbooked": false,
                            "registrationComplete": false
                          });
                        }
                        Navigator.pop(context);
                      }
                      _areainputcontroller.clear();
                      _addplotscontroller.clear();
                      _directionFacingcontroller.clear();
                    })
              ],
            ));
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
                "Add Plots",
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
                      //initialValue: "1",
                      controller: _addplotscontroller,
                      decoration: const InputDecoration(
                        labelText: 'Number of items to add',
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter atleast one';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        //initialValue: "1200",
                        controller: _areainputcontroller,
                        decoration: const InputDecoration(
                          labelText: 'Total sq.feet',
                          prefixIcon: Icon(Icons.aspect_ratio),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) return 'Please enter area';
                          return null;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      //initialValue: "1200",
                      //controller: _directionFacingcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Direction Facing',
                        prefixIcon: Icon(Icons.navigation),
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text("SE"),
                          value: "SE",
                        ),
                        DropdownMenuItem(
                          child: Text("NE"),
                          value: "NE",
                        ),
                        DropdownMenuItem(
                          child: Text("SW"),
                          value: "SW",
                        ),
                        DropdownMenuItem(
                          child: Text("NW"),
                          value: "NW",
                        ),
                        DropdownMenuItem(
                          child: Text("East"),
                          value: "East",
                        ),
                        DropdownMenuItem(
                          child: Text("West"),
                          value: "West",
                        ),
                        DropdownMenuItem(
                          child: Text("North"),
                          value: "North",
                        ),
                        DropdownMenuItem(
                          child: Text("South"),
                          value: "South",
                        ),
                      ],
                      onChanged: (value) => directionVal = value,
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

  editplotdetails(var plotdetails, var plot_docid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: editplots(plotdetails),
              actions: <Widget>[
                OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.red,
                    //button to save buyer info details to DB
                    child: Text(
                      'Remove',
                      style: TextStyle(
                          color: Colors.red[900], fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection(widget.promotorName)
                          .doc("Projects")
                          .collection("projectlist")
                          .doc(widget.doc_id)
                          .collection("plots")
                          .doc(plot_docid);
                      documentReference.delete();
                      Navigator.pop(context);
                    }),
                OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.green,
                    //button to save buyer info details to DB
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection(widget.promotorName)
                          .doc("Projects")
                          .collection("projectlist")
                          .doc(widget.doc_id)
                          .collection("plots")
                          .doc(plot_docid);
                      documentReference.update({
                        "area":
                            editarea == null ? plotdetails['area'] : editarea,
                        "directionFacing":
                            directionVal == plotdetails['directionFacing']
                                ? plotdetails['directionFacing']
                                : directionVal
                      });
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  Widget editplots(var plotdetails) {
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
                "Edit Plot Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                //key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: plotdetails["area"],
                      //controller: _editareacontroller,
                      decoration: const InputDecoration(
                        labelText: 'Edit area',
                        prefixIcon: Icon(Icons.aspect_ratio),
                      ),
                      onChanged: (value) => editarea = value,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter some text';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: plotdetails['directionFacing'],
                      //controller: _directionFacingcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Direction Facing',
                        prefixIcon: Icon(Icons.navigation),
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text("SE"),
                          value: "SE",
                        ),
                        DropdownMenuItem(
                          child: Text("NE"),
                          value: "NE",
                        ),
                        DropdownMenuItem(
                          child: Text("SW"),
                          value: "SW",
                        ),
                        DropdownMenuItem(
                          child: Text("NW"),
                          value: "NW",
                        ),
                        DropdownMenuItem(
                          child: Text("East"),
                          value: "East",
                        ),
                        DropdownMenuItem(
                          child: Text("West"),
                          value: "West",
                        ),
                        DropdownMenuItem(
                          child: Text("North"),
                          value: "North",
                        ),
                        DropdownMenuItem(
                          child: Text("South"),
                          value: "South",
                        ),
                      ],
                      onChanged: (value) => directionVal = value,
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

  @override
  void dispose() {
    _buyernamecontroller.dispose();
    _phonenumbercontroller.dispose();
    super.dispose();
  }
}
