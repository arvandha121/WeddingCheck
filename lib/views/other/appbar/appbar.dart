import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weddingcheck/app/provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({Key? key}) : super(key: key);

  final Uri url = Uri.parse('https://excelexample.arvandhaa.my.id');

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
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
