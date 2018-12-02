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
    String barcode = await QRCodeReader().scan();
//    barcode = 'Y6wuVqHYpBX2W6rp9CxK';
    Firestore.instance
        .collection('events')
        .document(barcode)
        .setData({'id': barcode});
    var snapshot = await Firestore.instance
        .collection('participants')
        .document(barcode)
        .get();

    barcode = (snapshot.exists)
        ? snapshot.data.toString()
        : "El participant $barcode no existeix!!";

    setState(() => this.barcode = barcode);
  }
}
