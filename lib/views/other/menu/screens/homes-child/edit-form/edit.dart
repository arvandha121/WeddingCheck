import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';

class Edits extends StatefulWidget {
  final ListItem item;
  final VoidCallback onEditSuccess; // Callback to be called on successful edit

  const Edits({Key? key, required this.item, required this.onEditSuccess})
      : super(key: key);

  @override
  _EditsState createState() => _EditsState();
}

class _EditsState extends State<Edits> {
  late TextEditingController nameController;
  late TextEditingController alamatController;
  late TextEditingController kotaController;
  late TextEditingController kecamatanController;
  late TextEditingController keluargaController;
  late TextEditingController gambarController;
  late TextEditingController keteranganController;

  String? currentStatus;
  final formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<String> statusOptions = ['belum hadir', 'hadir'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.nama);
    alamatController = TextEditingController(text: widget.item.alamat);
    kotaController = TextEditingController(text: widget.item.kota);
    kecamatanController = TextEditingController(text: widget.item.kecamatan);
    keluargaController = TextEditingController(text: widget.item.keluarga);
    gambarController = TextEditingController(text: widget.item.gambar);
    keteranganController = TextEditingController(text: widget.item.keterangan);
    currentStatus = widget.item.keterangan;
  }

  void updateListItem() async {
    if (formKey.currentState!.validate()) {
      ListItem updatedItem = ListItem(
        id: widget.item.id,
        parentId: widget.item.parentId,
        nama: nameController.text,
        alamat: alamatController.text,
        kota: kotaController.text,
        kecamatan: kecamatanController.text,
        keluarga: keluargaController.text,
        gambar: gambarController.text,
        keterangan: currentStatus ?? widget.item.keterangan,
      );

      Navigator.pop(context, true);

      await dbHelper.updateListItem(updatedItem);

      // Display a Snackbar with a success message
      Get.snackbar(
          "Success", // title
          "Item updated successfully", // message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 20,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 3) // Duration the Snackbar is visible
          );

      // Optionally, you can call the callback to inform any parent widgets of the update
      widget.onEditSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
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
              Visibility(
                visible: false, // Set to false to hide the TextFormField
                child: TextFormField(
                  controller: gambarController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: currentStatus,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.info),
                ),
                items: statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    currentStatus = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateListItem,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
