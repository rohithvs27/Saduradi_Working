import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
int testdata;

class GetPlotFilterCount {
  Future<int> bookedCount(uid, docid) async {
    await db
        .collection("data")
        .doc(uid)
        .collection("projects")
        .doc(docid)
        .collection("plots")
        .where("isbooked", isEqualTo: false)
        .get()
        .then((value) => testdata = value.docs.length);
    return testdata;
  }
}
