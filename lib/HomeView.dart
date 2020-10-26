import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/plotnames.dart';
import 'package:saduradi_phone_signin/services/filterdata.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';
import 'package:saduradi_phone_signin/widgets/createnewemp.dart';

var promotor_name = "Loading...";
var plotcount;

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
    setState(() {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: widget.admin
            ? Scaffold(
                appBar: customAppbar(context, widget.promotorName),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  currentIndex: _cIndex,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.business), title: Text("Add Project")),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_add),
                        title: Text("Manage Employee")),
                  ],
                  selectedItemColor: Colors.blue[800],
                  unselectedItemColor: Colors.blue[800],
                  unselectedFontSize: 14,
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
                              // print(snapshot.data.documents[index].id);
                              return Container(
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      title: Text(
                                        snapshot.data.documents[index].id
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: StreamBuilder(
                                        stream:
                                            getProjectDetailsStreamSnapshots(
                                                context,
                                                snapshot
                                                    .data.documents[index].id),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return const AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: Text(
                                                "Loading...",
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          return new Text(
                                            "Plots # : ${snapshot.data.documents.length}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: snapshot.data.documents
                                                            .length ==
                                                        0
                                                    ? Colors.red
                                                    : Colors.green),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => PlotNames(
                                                    widget.promotorName,
                                                    widget.uid,
                                                    snapshot.data
                                                        .documents[index].id,
                                                    widget.admin,
                                                    widget.empname)));
                                      },
                                    ),
                                  ),
                                ),
                              );
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
                              // print(snapshot.data.documents[index].id);
                              return Container(
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      title: Text(
                                        snapshot.data.documents[index].id
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: StreamBuilder(
                                        stream:
                                            getProjectDetailsStreamSnapshots(
                                                context,
                                                snapshot
                                                    .data.documents[index].id),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return const AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: Text(
                                                "Loading...",
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          return new Text(
                                            "Plots # : ${snapshot.data.documents.length}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: snapshot.data.documents
                                                            .length ==
                                                        0
                                                    ? Colors.red
                                                    : Colors.green),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => PlotNames(
                                                    widget.promotorName,
                                                    widget.uid,
                                                    snapshot.data
                                                        .documents[index].id,
                                                    widget.admin,
                                                    widget.empname)));
                                      },
                                    ),
                                  ),
                                ),
                              );
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
                FlatButton(
                  color: Colors.green,
                  child: Text('Submit'),
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

  getProjectDetailsfutureSnapshots(projectId) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(widget.promotorName);
    return collectionReference
        .doc("Projects")
        .collection("projectlist")
        .doc(projectId)
        .collection("plots")
        .where("isbooked", isEqualTo: false)
        .snapshots();
  }
}
