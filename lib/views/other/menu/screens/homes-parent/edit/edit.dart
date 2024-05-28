import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';

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
      appBar: AppBar(
        title: Text("Edit Files"),
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
                controller: titleController,
                labelText: "Title",
                icon: Icons.push_pin,
                validator: (value) =>
                    value!.isEmpty ? "Title tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: namapriaController,
                labelText: "Nama Pria",
                icon: Icons.male_outlined,
                validator: (value) =>
                    value!.isEmpty ? "Nama pria tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: namawanitaController,
                labelText: "Nama Wanita",
                icon: Icons.female_outlined,
                validator: (value) =>
                    value!.isEmpty ? "Nama wanita tidak boleh kosong" : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: tanggalController,
                labelText: "Tanggal",
                icon: Icons.calendar_today,
                validator: (value) =>
                    value!.isEmpty ? "Tanggal tidak boleh kosong" : null,
                onTap: () => _selectDate(context, tanggalController),
                readOnly: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: akadController,
                labelText: "Akad (Jam Mulai - Selesai)",
                icon: Icons.timer,
                validator: (value) =>
                    value!.isEmpty ? "Akad tidak boleh kosong" : null,
                onTap: () => _selectTime(context, akadController),
                readOnly: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: resepsiController,
                labelText: "Resepsi (Jam Mulai - Selesai)",
                icon: Icons.timer,
                validator: (value) =>
                    value!.isEmpty ? "Resepsi tidak boleh kosong" : null,
                onTap: () => _selectResepsiTime(context, resepsiController),
                readOnly: true,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: lokasiController,
                labelText: "Lokasi",
                icon: Icons.map,
                validator: (value) =>
                    value!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateParentListItem,
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    VoidCallback? onTap,
    bool readOnly = false,
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
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
    );
  }
}
