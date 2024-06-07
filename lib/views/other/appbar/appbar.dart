import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:flutter/services.dart'; // Import this for Clipboard

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({Key? key}) : super(key: key);

  final Uri url = Uri.parse('https://excelexample.arvandhaa.my.id');

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: url.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link berhasil tersalin'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Wedding Check"),
      backgroundColor: Colors.deepPurple,
      actions: [
        IconButton(
          icon: Icon(Icons.info),
          tooltip: 'Information',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    "Template Import Excel",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Klik button di bawah untuk mengunduh template excel list tamu",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.download, color: Colors.white),
                        label: Text('Download Template'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () async {
                          _launchUrl();
                        },
                      ),
                      SizedBox(height: 10), // Add some space between buttons
                      Text("Atau"),
                      SizedBox(height: 10), // Add some space between buttons
                      ElevatedButton.icon(
                        icon: Icon(Icons.copy, color: Colors.white, size: 20),
                        label: Text('Copy Link Gdrive'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () async {
                          _copyUrl(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
