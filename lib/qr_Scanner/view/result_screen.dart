import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QrResultScreen extends StatefulWidget {
  List resultQr = [];
   QrResultScreen({super.key,required this.resultQr});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:  AppBar( centerTitle: true,
      title: Text('Place the Qr in the area',style: TextStyle(
          color: Colors.black87,
          letterSpacing: 1,
          fontWeight: FontWeight.bold)),) ,
      body: Container(padding: EdgeInsets.all(12.0),
          child:Column(children: [
            Text(widget.resultQr[0],style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1,
                fontWeight: FontWeight.bold)),

          ],) ),
    );
  }
}
