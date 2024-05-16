import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes/detail-form/detail.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      final String scannedData = scanData.code ?? "";
      fetchListItemByGambar(scannedData).then((item) {
        if (item != null) {
          // Update keterangan menjadi 'hadir'
          DatabaseHelper().updateKeteranganHadir(item.id!).then((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(item: item),
              ),
            ).then((_) => controller.resumeCamera());
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Invalid QR Code or item not found."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.resumeCamera();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
      refreshCamera();
    });
    refreshCamera();
  }

  void refreshCamera() async {
    await controller?.pauseCamera();
    await controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR Code'),
            ),
          ),
        ],
      ),
    );
  }

  Future<ListItem?> fetchListItemByGambar(String gambar) async {
    DatabaseHelper list = await DatabaseHelper();
    return list.getListItemByGambar(gambar);
  }
}
