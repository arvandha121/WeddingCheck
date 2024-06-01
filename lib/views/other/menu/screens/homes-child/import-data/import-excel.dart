import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';

Future<void> importFromExcel(
    BuildContext context, int parentId, VoidCallback onSuccess) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      List<ListItem> listItems = [];

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows.skip(1)) {
          // Skip header row
          String nama = row[2]?.value.toString() ?? '';
          String alamat = row[3]?.value.toString() ?? '';
          String kota = row[4]?.value.toString() ?? '';
          String kecamatan = row[5]?.value.toString() ?? '';
          String keluarga = row[6]?.value.toString() ?? '';
          String keterangan = row[7]?.value.toString() ?? '';
          String gambar = "$nama${_generateRandomCode()}";

          // Validate keterangan field
          if (keterangan != 'hadir' && keterangan != 'belum hadir') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Invalid value for keterangan: $keterangan')),
            );
            print(keterangan);
            return;
          }

          listItems.add(ListItem(
            parentId: parentId,
            nama: nama,
            alamat: alamat,
            kota: kota,
            kecamatan: kecamatan,
            keluarga: keluarga,
            gambar: gambar,
            keterangan: keterangan,
          ));
        }
      }

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertListItems(listItems);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data imported successfully from Excel')),
      );

      // Call the onSuccess callback to refresh the data
      onSuccess();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to import data from Excel: $e')),
    );
    print(e);
  }
}

int? _parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is SharedString) {
    return int.tryParse(value.toString());
  }
  return null;
}

String _generateRandomCode() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    5,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}
