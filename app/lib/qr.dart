import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:image/image.dart';

class PageQR extends StatefulWidget {
  const PageQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageQRState();
}

class _PageQRState extends State<PageQR> {
  Uint8List bytes = Uint8List(0);
  CameraController? controller;
  int frameSkip = 0;
  JpegEncoder jpgOut = new JpegEncoder();
  JpegDecoder jpg = new JpegDecoder();
  CameraImage? image = null;
  Timer? timerP = null;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      controller = CameraController(cameras[0], ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.jpeg);
      controller!.initialize().then((cam) {
        if (!mounted) {
          return;
        }
        controller!.startImageStream((image) {
          this.image = image;
        });
        setState(() {});
      });
    });

    Timer.periodic(new Duration(seconds: 2), (timer) {
      timerP = timer;
      if (image == null) return;
      scanner
          .scanBytes(Uint8List.fromList(jpgOut.encodeImage(
              invert(grayscale(jpg.decodeImage(image!.planes[0].bytes))))))
          .then((barcode) {
        print(barcode);
      }).catchError((err) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
      body: Center(
        child: getCamera(),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    if (timerP != null) {
      timerP!.cancel();
    }
    super.dispose();
  }

  getCamera() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return CameraPreview(controller!);
  }
}
