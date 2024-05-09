import 'package:flutter/material.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final DatabaseHelper list = DatabaseHelper();

  void _deleteAllItems() async {
    var allItems = await list.readListItem();
    print("Items fetched for deletion: ${allItems.length}");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus semua data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await list.clearAllListItems();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Semua data berhasil dihapus.'),
                    duration: const Duration(seconds: 8),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () async {
                        if (!mounted) return;
                        print("Attempting to restore items");

                        for (var item in allItems) {
                          var result = await list.insertListItem(item);
                          print("Restore result for item ${item.id}: $result");
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      textColor: Colors.yellow,
                      disabledTextColor: Colors.grey,
                    ),
                  ),
                );
              },
              child: const Text(
                'Hapus Semua',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
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
            title: Text('Hapus Semua List'),
            subtitle: Text('Menghapus semua item yang tersimpan'),
            onTap: _deleteAllItems,
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Divider(),
          // Tambahkan pengaturan lain di sini
        ],
      ),
    );
  }
}
