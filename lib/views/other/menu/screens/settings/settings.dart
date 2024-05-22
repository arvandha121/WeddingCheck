import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:weddingcheck/views/splashscreen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UiProvider>(
            builder: (context, UiProvider notifier, child) {
          return AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content:
                const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<UiProvider>(context, listen: false)
                      .logout(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Splash(),
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Konfirmasi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Ketik "',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'hapus semua',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '" untuk konfirmasi:',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode konfirmasi',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    if (_textEditingController.text.toLowerCase() ==
                        'hapus semua') {
                      Navigator.of(context).pop();
                      DatabaseHelper().clearAllListItems();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi Gagal'),
                            content: const Text(
                                'Anda harus mengetik "hapus semua" untuk menghapus semua item.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Tutup'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Colors.redAccent,
              size: 40,
            ),
            title: Text(
              'Hapus Semua List',
            ),
            subtitle: Text(
              'Menghapus semua item yang tersimpan',
              selectionColor: Colors.grey[600],
            ),
            onTap: () => _showDeleteConfirmationDialog(context),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
              size: 40,
            ),
            title: Text('Logout'),
            subtitle: Text('Keluar dari akun Anda'),
            onTap: _confirmLogout,
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
