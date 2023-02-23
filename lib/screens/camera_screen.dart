import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String _scanResult = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late QRViewController controller;
  bool isCameraReady = false;
  bool isScannedDataScreenOpen = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Skenuj'),
      ),
      body: Stack(
        children: [
          _buildQRView(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_scanResult),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderColor: Colors.green,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!isScannedDataScreenOpen) {
        setState(() {
          _scanResult = scanData.code!;
          isScannedDataScreenOpen = true;
        });
        controller.pauseCamera();
        _findData(context).then((_) {
          controller.resumeCamera();
          isScannedDataScreenOpen = false;
        });
      }
    });
    controller.resumeCamera();
    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> _findData(BuildContext context) async {
    final CollectionReference qrcodes =
    FirebaseFirestore.instance.collection('pamatky');
    DocumentSnapshot snapshot = await qrcodes.doc(_scanResult).get();
    if (snapshot.exists) {
      Object? data = snapshot.data();
      controller.pauseCamera(); // pause the camera stream
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannedDataScreen(
            scannedData: data.toString(),
          ),
        ),
      ).then((_) {
        // resume the camera stream when the user pops the scanned data screen
        controller.resumeCamera();
      });
    } else {
      print('Data not found');
    }
  }
}

class ScannedDataScreen extends StatelessWidget {
  final String scannedData;
  ScannedDataScreen({required this.scannedData});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Naskenovaná data'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Text(scannedData),
        ),
      ),
    );
  }
}