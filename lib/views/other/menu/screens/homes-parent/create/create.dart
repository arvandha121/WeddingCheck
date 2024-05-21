import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:weddingcheck/views/homepage.dart';

class CreateParent extends StatefulWidget {
  const CreateParent({super.key});

  @override
  State<CreateParent> createState() => _CreateParentState();
}

class _CreateParentState extends State<CreateParent> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final namapriaController = TextEditingController();
  final namawanitaController = TextEditingController();
  final tanggalController = TextEditingController();
  final resepsiController = TextEditingController();
  final akadController = TextEditingController();
  final lokasiController = TextEditingController();

  final DatabaseHelper listparent = DatabaseHelper();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Waktu Mulai',
    );
    if (startTime == null) return; // User cancelled the picker

    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Waktu Selesai',
    );
    if (endTime == null) return; // User cancelled the picker

    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    setState(() {
      controller.text =
          '${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}';
    });
  }

  Future<void> _selectResepsiTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Waktu Mulai',
    );
    if (startTime != null) {
      final now = DateTime.now();
      final startDateTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);
      setState(() {
        controller.text =
            '${DateFormat('HH:mm').format(startDateTime)} - Selesai';
      });
    }
  }

  void create() async {
    if (formKey.currentState!.validate()) {
      try {
        await listparent.insertParentListItem(
          ParentListItem(
            title: titleController.text,
            namapria: namapriaController.text,
            namawanita: namawanitaController.text,
            tanggal: tanggalController.text,
            resepsi: resepsiController.text,
            akad: akadController.text,
            lokasi: lokasiController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Files")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.push_pin),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Title tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: namapriaController,
                decoration: InputDecoration(
                  labelText: "Nama Pria",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.man_outlined),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama pria tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: namawanitaController,
                decoration: InputDecoration(
                  labelText: "Nama Wanita",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.woman_outlined),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama wanita tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: tanggalController,
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                onTap: () => _selectDate(context, tanggalController),
                readOnly: true, // Prevent manual editing
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: akadController,
                decoration: InputDecoration(
                  labelText: "Akad (Jam Mulai - Selesai)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Akad tidak boleh kosong" : null,
                onTap: () => _selectTime(context, akadController),
                readOnly: true,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: resepsiController,
                decoration: InputDecoration(
                  labelText: "Resepsi (Jam Mulai - Selesai)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Resepsi tidak boleh kosong" : null,
                onTap: () => _selectResepsiTime(context, resepsiController),
                readOnly: true,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: "Lokasi",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: create,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
