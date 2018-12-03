import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hackaton 2018 QR Test'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(barcode),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: scan, child: Icon(Icons.camera_alt)),
      ),
    );
  }

  Future scan() async {
    String qrData = await QRCodeReader().scan();
    var toShow;
//    qrData = 'Y6wuVqHYpBX2W6rp9CxK';
    var snapshot = await Firestore.instance
        .collection('participants')
        .document(qrData)
        .get();

    if (snapshot.exists) {
      Firestore.instance
          .collection('events')
          .document(qrData)
          .setData({'id': qrData});
      toShow = snapshot.data.toString();
    } else {
      Firestore.instance
          .collection('fails')
          .document(qrData)
          .setData({'id': qrData});
      toShow = "El participant $qrData no existeix!!";
    }

    setState(() => this.barcode = toShow);
  }
}
