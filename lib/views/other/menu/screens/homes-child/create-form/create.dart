import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';

class Create extends StatefulWidget {
  final int parentId;
  const Create({Key? key, required this.parentId}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final alamatController = TextEditingController();
  final kotaController = TextEditingController();
  final kecamatanController = TextEditingController();
  final keluargaController = TextEditingController();
  final nohpController = TextEditingController();
  final gambarController = TextEditingController();
  final keteranganController = TextEditingController(text: "belum hadir");

  final DatabaseHelper list = DatabaseHelper();
  final Set<String> generatedCodes = {};

  void create() async {
    if (formKey.currentState!.validate()) {
      // Set the gambarController text to name and keluarga values
      gambarController.text = "${nameController.text}${_generateRandomCode()}";

      if (keluargaController.text.isEmpty) {
        keluargaController.text = "-";
      }
      if (nohpController.text.isEmpty) {
        nohpController.text = "-";
      }

      try {
        await list.insertListItem(
          ListItem(
            parentId: widget.parentId,
            nama: nameController.text,
            alamat: alamatController.text,
            kota: kotaController.text,
            kecamatan: kecamatanController.text,
            keluarga: keluargaController.text,
            nohp: nohpController.text,
            gambar: gambarController.text,
            keterangan: keteranganController.text,
          ),
        );
        Navigator.pop(context, true);
        Get.snackbar(
          "Success",
          "Item created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to create item: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Function to generate a random 5-character alphanumeric code
  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      5,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 8),
              _buildTextField(
                controller: nameController,
                labelText: "Nama",
                icon: Icons.person,
                validator: (value) =>
                    value!.isEmpty ? "Textfield nama tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: keluargaController,
                labelText: "Keluarga (boleh kosong)",
                icon: Icons.group,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: alamatController,
                labelText: "Alamat",
                icon: Icons.location_city,
                validator: (value) => value!.isEmpty
                    ? "Textfield alamat tidak boleh kosong"
                    : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: kotaController,
                labelText: "Kota",
                icon: Icons.location_on,
                validator: (value) =>
                    value!.isEmpty ? "Textfield kota tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: kecamatanController,
                labelText: "Kecamatan",
                icon: Icons.map,
                validator: (value) => value!.isEmpty
                    ? "Textfield kecamatan tidak boleh kosong"
                    : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: nohpController,
                labelText: "Nomor HP (boleh kosong)",
                icon: Icons.phone,
                onChanged: (value) {
                  if (!value.startsWith("+62")) {
                    nohpController.text = "+62";
                    nohpController.selection = TextSelection.fromPosition(
                      TextPosition(offset: nohpController.text.length),
                    );
                  }
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: create,
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(icon),
        filled: true,
      ),
      validator: validator ?? (value) => null,
      onChanged: onChanged,
    );
  }
}
