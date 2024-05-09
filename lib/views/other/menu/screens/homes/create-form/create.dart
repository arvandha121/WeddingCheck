import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/views/homepage.dart';
import 'dart:math';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

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
  final gambarController = TextEditingController();
  final keteranganController = TextEditingController(text: "belum hadir");

  final DatabaseHelper list = DatabaseHelper();

  void create() async {
    if (formKey.currentState!.validate()) {
      try {
        await list.insertListItem(
          ListItem(
            nama: nameController.text,
            alamat: alamatController.text,
            kota: kotaController.text,
            kecamatan: kecamatanController.text,
            keluarga: keluargaController.text,
            gambar: gambarController.text,
            keterangan: keteranganController.text,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        Get.snackbar(
          "Success",
          "Item created successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to create item: $e",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      int randomId = Random().nextInt(10000);
      String formattedDate = "${picked.toLocal()}".split(' ')[0];
      gambarController.text = "$formattedDate-$randomId";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Data"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: keluargaController,
                decoration: InputDecoration(
                  labelText: "Keluarga",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Keluarga tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Alamat tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: kotaController,
                decoration: InputDecoration(
                  labelText: "Kota",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Kota tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: kecamatanController,
                decoration: InputDecoration(
                  labelText: "Kecamatan",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Kecamatan tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: gambarController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Tanggal tidak boleh kosong" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: create,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
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
}
