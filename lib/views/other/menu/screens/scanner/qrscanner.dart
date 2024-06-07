import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-parent/homes.dart';
import 'package:flutter/services.dart'; // Import this for SystemNavigator.pop()

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool isFlashOn = false;

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

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    controller?.toggleFlash();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      final String scannedData = scanData.code ?? "";
      fetchListItemByGambar(scannedData).then((item) {
        if (item != null) {
          if (item.keterangan == "belum hadir") {
            updateListItemStatus(item.id!).then(
              (_) {
                // Ensure updateListItemStatus accepts only one argument
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfrimasi"),
                      content: Text("${item.nama} terdaftar hadir."),
                      actions: <Widget>[
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
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Ditolak"),
                  content: Text(
                      "Akses ditolak karena ${item.nama} telah terdaftar."),
                  actions: <Widget>[
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Kode QR tidak valid atau item tidak ditemukan."),
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
    });
    controller.resumeCamera();
  }

  Future<void> updateListItemStatus(int id) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.updateKeteranganHadir(id);
    if (mounted) {
      setState(() {});
    }
  }

  Future<ListItem?> fetchListItemByGambar(String gambar) async {
    DatabaseHelper list = await DatabaseHelper();
    return list.getListItemByGambar(gambar);
  }

  Future<bool> _onWillPop() async {
    controller?.pauseCamera(); // Pause the camera when the dialog appears
    bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi Keluar'),
            content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  controller
                      ?.resumeCamera(); // Resume the camera if "Tidak" is pressed
                },
                child: Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  controller
                      ?.stopCamera(); // Stop the camera if "Iya" is pressed
                },
                child: Text(
                  'Iya',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldExit) {
      SystemNavigator.pop(); // Close the application
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: _toggleFlash,
                child: Icon(
                  isFlashOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                ),
                backgroundColor:
                    isFlashOn ? Colors.yellow[700] : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
