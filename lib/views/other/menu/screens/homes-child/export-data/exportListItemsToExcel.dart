import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:intl/intl.dart'; // Add this import for DateFormat

Future<void> exportListItemsToExcel(
    BuildContext context, List<ListItem> items) async {
  // Request storage permissions
  PermissionStatus status = await Permission.storage.request();

  if (status == PermissionStatus.granted) {
    var excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, "Sheet1");

    Sheet sheetObject = excel["Sheet1"];

    // Add header row
    sheetObject.appendRow([
      'id',
      'parentId',
      'nama',
      'alamat',
      'kota',
      'kecamatan',
      'keluarga',
      'keterangan'
    ]);

    // Add data rows
    for (var item in items) {
      // Debugging: Print item details
      print(
          'Adding item: ${item.parentId}, ${item.nama}, ${item.alamat}, ${item.kota}, ${item.kecamatan}, ${item.keluarga ?? ''}, ${item.keterangan}');

      sheetObject.appendRow([
        item.id,
        item.parentId,
        item.nama,
        item.alamat,
        item.kota,
        item.kecamatan,
        item.keluarga,
        item.keterangan
      ]);
    }

    try {
      DateTime now = DateTime.now();
      String date = DateFormat('ddMMyyyy').format(now);
      String fileName = 'listitem$date.xlsx';

      var fileBytes = excel.save();
      var directory = Directory('/storage/emulated/0/Download');

      if (fileBytes != null) {
        // Ensure the directory exists
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Construct the file path correctly
        final path = join(directory.path, fileName);
        final file = File(path);

        await file.writeAsBytes(fileBytes, flush: true).then((value) {
          print('File saved successfully at $path');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Excel file saved successfully at $path')),
          );
        });
      } else {
        throw Exception('Failed to encode Excel file');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save Excel file: $e')),
      );
    }
  } else if (status == PermissionStatus.denied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Storage permission denied')),
    );
  } else if (status == PermissionStatus.permanentlyDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Storage permission permanently denied. Please enable it from settings.'),
      ),
    );
  }
}
