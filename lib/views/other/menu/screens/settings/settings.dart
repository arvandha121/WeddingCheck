import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            onTap: () {
              // Assuming delete all items logic is handled elsewhere
            },
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
