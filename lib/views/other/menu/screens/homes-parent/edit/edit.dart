import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:weddingcheck/views/homepage.dart';

class EditParents extends StatefulWidget {
  final ParentListItem item;
  final VoidCallback onEditSuccess;

  const EditParents({
    Key? key,
    required this.item,
    required this.onEditSuccess,
  }) : super(key: key);

  @override
  State<EditParents> createState() => _EditParentsState();
}

class _EditParentsState extends State<EditParents> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController namapriaController;
  late TextEditingController namawanitaController;
  late TextEditingController tanggalController;
  late TextEditingController resepsiController;
  late TextEditingController akadController;
  late TextEditingController lokasiController;

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    namapriaController = TextEditingController(text: widget.item.namapria);
    namawanitaController = TextEditingController(text: widget.item.namawanita);
    tanggalController = TextEditingController(text: widget.item.tanggal);
    resepsiController = TextEditingController(text: widget.item.resepsi);
    akadController = TextEditingController(text: widget.item.akad);
    lokasiController = TextEditingController(text: widget.item.lokasi);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
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

  void updateParentListItem() async {
    if (formKey.currentState!.validate()) {
      ParentListItem updatedItem = ParentListItem(
        id: widget
            .item.id, // Make sure to pass the ID if it's needed for updating
        title: titleController.text,
        namapria: namapriaController.text,
        namawanita: namawanitaController.text,
        tanggal: tanggalController.text,
        resepsi: resepsiController.text,
        akad: akadController.text,
        lokasi: lokasiController.text,
      );
      await dbHelper.updateParentListItem(updatedItem);

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
        duration: Duration(seconds: 3), // Duration the Snackbar is visible
      );

      widget.onEditSuccess(); // Call the callback
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Files")),
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
                  prefixIcon: Icon(Icons.person),
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
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: namawanitaController,
                decoration: InputDecoration(
                  labelText: "Nama Wanita",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
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
                onPressed: updateParentListItem,
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
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
