import 'package:flutter/material.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Detail extends StatefulWidget {
  final ListItem item;
  const Detail({Key? key, required this.item}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    // Determine if the theme is dark
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Set QR code colors based on the theme
    Color qrForegroundColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Detail Page"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              shadowColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.item.nama,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      subtitle: Text("${widget.item.keterangan}",
                          style: TextStyle(
                              color: _getColorForKeterangan(
                                  widget.item.keterangan),
                              fontSize: 16)),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple[100],
                        child: Icon(Icons.person,
                            size: 40, color: Colors.deepPurple[900]),
                      ),
                    ),
                    Divider(thickness: 2),
                    infoSection(Icons.home, "Alamat", widget.item.alamat),
                    infoSection(Icons.location_city, "Kota", widget.item.kota),
                    infoSection(Icons.map, "Kecamatan", widget.item.kecamatan),
                    infoSection(Icons.family_restroom, "Keluarga",
                        widget.item.keluarga),
                    infoSection(Icons.phone, "No Hp", widget.item.nohp),
                    SizedBox(height: 20),
                    Center(
                      child: QrImage(
                        data: widget.item.gambar,
                        version: QrVersions.auto,
                        size: 200.0,
                        // backgroundColor: qrBackgroundColor,
                        foregroundColor: qrForegroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForKeterangan(String? keterangan) {
    if (keterangan == 'hadir') {
      return Colors.green;
    } else if (keterangan == 'belum hadir') {
      return Colors.red;
    } else {
      return Colors.black; // Default color if neither
    }
  }

  Widget infoSection(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple[900]),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(value ?? 'Not available', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
