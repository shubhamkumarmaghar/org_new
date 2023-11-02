
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:partypeoplebusiness/qr_Scanner/view/result_screen.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  bool isScanCompleted = false;
  List qrList = [];

  void closeScreen(){
    isScanCompleted=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(// centerTitle: true,
        title: Text('Qr Scanner',style: TextStyle(
          color: Colors.white,
          letterSpacing: 1,
          fontWeight: FontWeight.bold)),) ,
      backgroundColor: Colors.black54,
      body:Container(
        width: double.infinity,
      padding: EdgeInsets.all(16),
        child: Column(
            children: [
          Expanded(
              child: Container(
                // color: Colors.red,
              child: Column(children: [
                Text('Place the Qr in the area',style: TextStyle(fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                Text('Scanning will be started automatically',
                    style: TextStyle(fontSize: 16,color: Colors.white70)),
              ]),
              )
          ),
              Expanded(
                flex: 4,
                  child: MobileScanner(
                    controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.normal,
                    facing: CameraFacing.back,
                    //torchEnabled: true,
                  ),
                    onDetect: (capture) {
                      if(!isScanCompleted){
                       // String code = capture.barcodes;
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;
                        for (final barcode in barcodes) {
                          log('scanner detais ${barcode.rawValue}');
                          debugPrint('Barcode found! ${barcode.rawValue}');
                          qrList.add(barcode.rawValue);
                        }
                        isScanCompleted=true;
                        Get.off(QrResultScreen(resultQr: qrList,));
                      }

                  },)
              ),

              Expanded(
                  child: Container(//color: Colors.amber,
                    child: Column(children: [
                      SizedBox(height: 10,),
                      Text('Powered by PartyPeople',
                        style: TextStyle(fontSize: 18,color: Colors.white70)
                    ),],),

                  )
              )
            ]),
      ) ,
    );
  }
}
