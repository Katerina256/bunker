import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bunker/data.dart';
import 'package:bunker/player.dart';
import 'package:bunker/qr_scanner_overlay_shape.dart';
import 'package:bunker/storage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class PageQR extends StatefulWidget {
  const PageQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageQRState();
}

class _PageQRState extends State<PageQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
      appBar: AppBar(title: Text('QR код')),
      body: Center(
        child: getCamera(context),
      ),
    );
  }

  getCamera(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 100.0
        : 200.0;

    return Stack(
      fit: StackFit.expand,
      children: [
        QRCodeDartScanView(
          formats: [BarcodeFormat.QR_CODE],
          scanInvertedQRCode: true,
          onCapture: (Result scanData) async {
            String barcode = scanData.text.trim();
            if (barcode != '') {
              if (BunkerData.qData.containsKey(barcode)) {
                BunkerStorage.event =
                    BunkerData.eData[BunkerData.qData[barcode]]!;
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PagePlayer()));
              }
            }
          },
        ),
        Container(
          decoration: ShapeDecoration(
            shape: QrScannerOverlayShape(
                borderColor: Colors.amber,
                borderRadius: 10,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: scanArea),
          ),
        )
      ],
    );
  }
}
