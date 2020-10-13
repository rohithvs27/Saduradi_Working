import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saduradi_phone_signin/plotnames.dart';
import 'package:saduradi_phone_signin/services/filterdata.dart';
import 'package:saduradi_phone_signin/widgets/Appbar.dart';

var promotor_name = "Loading...";
var plotcount;

class MyHomePage extends StatefulWidget {
  final String uid;
  MyHomePage(this.uid);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _projectnamecontroller = TextEditingController();
  GetPlotFilterCount getCount = new GetPlotFilterCount();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  Map<String, dynamic> data1 = {
    "plotname": 1,
    "area": "1234",
    "isbooked": false,
    "registrationComplete": false
  };
  String docid = "KPM";

  get_promotorName() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('data').doc(widget.uid);
    documentReference.snapshots().listen((snapshot) {
      setState(() {
        promotor_name = snapshot.get("promotor_name");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    get_promotorName();
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context, promotor_name),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            setState(() {
              addnewproject();
              _projectnamecontroller.clear();
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
                return new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 80,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            shadowColor: Colors.black,
                            elevation: 5,
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: 20, top: 10),
                              title: Text(
                                snapshot.data.documents[index].id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => PlotNames(
                                              widget.uid,
                                              snapshot.data.documents[index].id,
                                            )));
                              },
                            )),
                      );
                    });
              },
            )),
          ]),
        ),
      ),
    );
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    DocumentReference docref = FirebaseFirestore.instance
                        .collection('data')
                        .doc(widget.uid)
                        .collection("projects")
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
        .collection('data')
        .doc(widget.uid)
        .collection("projects")
        .snapshots();
  }
}
