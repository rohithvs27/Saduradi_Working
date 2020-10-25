import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget showbuyerinfoalert(var buyerinfo) {
  Color showinfo = Colors.black;
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    // color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  children: [
                    Icon(Icons.attach_money),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(20),
                      child: Text(
                        buyerinfo["bookingamount"],
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    // color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.all(20),
                      child: Text(
                        buyerinfo["bookingperson"],
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
