import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/plotnames.dart';
import 'package:saduradi_phone_signin/reportscreen.dart';
import 'package:saduradi_phone_signin/services/filterdata.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';
import 'package:saduradi_phone_signin/widgets/createnewemp.dart';

var promotor_name = "Loading...";
var plotcount;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyHomePage extends StatefulWidget {
  final bool admin;
  final String uid;
  final String promotorName;
  final String empname;
  MyHomePage(this.promotorName, this.uid, this.admin, this.empname);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _cIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _projectnamecontroller = TextEditingController();
  GetPlotFilterCount getCount = new GetPlotFilterCount();

  void _selectedTab(index) {
    _cIndex = index;
    print(_cIndex);
    switch (_cIndex) {
      case 0:
        {
          addnewproject();
          _projectnamecontroller.clear();
        }
        break;
      case 1:
        {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => CreateNewEmp(widget.promotorName)));
        }
        break;
      case 2:
        {
          //T0do
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: widget.admin
            ? Scaffold(
                appBar: customAppbar(context, widget.promotorName),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _cIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      title: Text("Add Project"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add),
                      title: Text("Add Employee"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt),
                      title: Text("Reports"),
                    ),
                  ],
                  showUnselectedLabels: true,
                  selectedItemColor: Colors.indigo,
                  unselectedItemColor: Colors.indigo,
                  selectedFontSize: 12,
                  onTap: (index) {
                    _selectedTab(index);
                  },
                ),
                body: Container(
                  height: size.height,
                  child: Column(children: <Widget>[
                    Expanded(
                        child: StreamBuilder(
                      stream: getPromoterProjectStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: LinearProgressIndicator(),
                          );
                        return new ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              // print(snapshot.data.documents[index].id);
                              return Container(
                                  child: InkWell(
                                child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: size.width * 0.7,
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                                snapshot
                                                    .data.documents[index].id,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))),
                                        Container(
                                          width: size.width * 0.13,
                                          child: FutureBuilder<QuerySnapshot>(
                                            future:
                                                getProjectDetailsfutureSnapshots(
                                                    snapshot.data
                                                        .documents[index].id,
                                                    false),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        LinearProgressIndicator(),
                                                  );
                                                } else {
                                                  return Center(
                                                      // here only return is missing
                                                      child: Text(
                                                    snapshot.data.docs.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.green[800]),
                                                  ));
                                                }
                                              } else if (snapshot.hasError) {
                                                Text('no data');
                                              }
                                              return LinearProgressIndicator();
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.13,
                                          child: FutureBuilder<QuerySnapshot>(
                                            future:
                                                getProjectDetailsfutureSnapshots(
                                                    snapshot.data
                                                        .documents[index].id,
                                                    true),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return LinearProgressIndicator();
                                                } else {
                                                  return Center(
                                                      // here only return is missing
                                                      child: Text(
                                                    snapshot.data.docs.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red[800]),
                                                  ));
                                                }
                                              } else if (snapshot.hasError) {
                                                Text('no data');
                                              }
                                              return LinearProgressIndicator();
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => PlotNames(
                                              widget.promotorName,
                                              widget.uid,
                                              snapshot.data.documents[index].id,
                                              widget.admin,
                                              widget.empname)));
                                },
                              ));
                            });
                      },
                    )),
                  ]),
                ),
              )
            : Scaffold(
                appBar: customAppbar(context, widget.promotorName),
                body: Container(
                  height: size.height,
                  child: Column(children: <Widget>[
                    Expanded(
                        child: StreamBuilder(
                      stream: getPromoterProjectStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: LinearProgressIndicator());
                        return new ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              // print(snapshot.data.documents[index].id);
                              return Container(
                                  child: InkWell(
                                child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: size.width * 0.7,
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                                snapshot
                                                    .data.documents[index].id,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                ))),
                                        Container(
                                          width: size.width * 0.13,
                                          child: FutureBuilder<QuerySnapshot>(
                                            future:
                                                getProjectDetailsfutureSnapshots(
                                                    snapshot.data
                                                        .documents[index].id,
                                                    false),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 0.5,
                                                    ),
                                                  );
                                                } else {
                                                  return Center(
                                                      // here only return is missing
                                                      child: Text(
                                                    snapshot.data.docs.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.green[800]),
                                                  ));
                                                }
                                              } else if (snapshot.hasError) {
                                                Text('no data');
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.13,
                                          child: FutureBuilder<QuerySnapshot>(
                                            future:
                                                getProjectDetailsfutureSnapshots(
                                                    snapshot.data
                                                        .documents[index].id,
                                                    true),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Center(
                                                      // here only return is missing
                                                      child: Text(
                                                    snapshot.data.docs.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red[800]),
                                                  ));
                                                }
                                              } else if (snapshot.hasError) {
                                                Text('no data');
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => PlotNames(
                                              widget.promotorName,
                                              widget.uid,
                                              snapshot.data.documents[index].id,
                                              widget.admin,
                                              widget.empname)));
                                },
                              ));
                            });
                      },
                    )),
                  ]),
                ),
              ));
  }

  addnewproject() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                  width: double.maxFinite,
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10),
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Center(
                            child: Column(children: <Widget>[
                          Text(
                            "Add New Project",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Form(
                              key: _formKey,
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _projectnamecontroller,
                                  decoration: const InputDecoration(
                                    labelText: 'Project Name',
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'Please enter some text';
                                    return null;
                                  },
                                )
                              ]))
                        ]))
                      ])),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.white,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  color: Colors.white,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    DocumentReference docref = FirebaseFirestore.instance
                        .collection(widget.promotorName)
                        .doc("Projects")
                        .collection("projectlist")
                        .doc(_projectnamecontroller.text.trim());

                    docref.set(
                        {"projectname": _projectnamecontroller.text.trim()});
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Stream<QuerySnapshot> getPromoterProjectStreamSnapshots(
      BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection(widget.promotorName)
        .doc("Projects")
        .collection("projectlist")
        .snapshots();
  }

  Stream<QuerySnapshot> getProjectDetailsStreamSnapshots(
      BuildContext context, String projectId) async* {
    yield* FirebaseFirestore.instance
        .collection(widget.promotorName)
        .doc("Projects")
        .collection("projectlist")
        .doc(projectId)
        .collection("plots")
        .where("isbooked", isEqualTo: false)
        .snapshots();
  }

  Future<QuerySnapshot> getProjectDetailsfutureSnapshots(
      projectId, bookedstatus) async {
    return await firestore
        .collection(widget.promotorName)
        .doc("Projects")
        .collection("projectlist")
        .doc(projectId)
        .collection("plots")
        .where("isbooked", isEqualTo: bookedstatus)
        .get();
  }
}
