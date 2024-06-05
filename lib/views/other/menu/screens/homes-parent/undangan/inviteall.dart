import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:archive/archive.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AllInvitationsPage extends StatefulWidget {
  final int parentId;

  const AllInvitationsPage({Key? key, required this.parentId})
      : super(key: key);

  @override
  _AllInvitationsPageState createState() => _AllInvitationsPageState();
}

class _AllInvitationsPageState extends State<AllInvitationsPage> {
  ParentListItem? _parentItem;
  List<ListItem> _childrenItems = [];
  bool _isLoading = true;
  final List<GlobalKey> _boundaryKeys = [];

  @override
  void initState() {
    super.initState();
    print("AllInvitationsPage initState called");
    initializeDateFormatting('id_ID', null).then((_) {
      _loadInvitationData();
    });
  }

  Future<void> _loadInvitationData() async {
    print("Loading invitation data...");
    try {
      final data = await DatabaseHelper().getInvitationData(widget.parentId);
      final items = await DatabaseHelper().getAllDownloadListItems(
          widget.parentId); // Get list items by parentId
      setState(
        () {
          _parentItem = data['parent'];
          _childrenItems = items; // Use list items by parentId
          _boundaryKeys.clear();
          _boundaryKeys
              .addAll(List.generate(_childrenItems.length, (_) => GlobalKey()));
          _isLoading = false;
        },
      );
      print("Invitation data loaded successfully");
    } catch (e) {
      print("Error loading invitation data: $e");
    }
  }

  String _formatDate(String date) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = inputFormat.parse(date);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    print("AllInvitationsPage build called");
    Color isDarkMode = Theme.of(context).brightness == Brightness.dark
        ? Colors.yellow
        : Colors.deepPurple;
    bool isDarkModes = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkModes ? Colors.black : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text('Undangan Pernikahan'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadAllInvitations,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: List.generate(
                  _childrenItems.length,
                  (index) {
                    final item = _childrenItems[index];
                    final key = _boundaryKeys[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RepaintBoundary(
                        key: key,
                        child:
                            _buildInvitationCard(item, isDarkMode, textColor),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildInvitationCard(
      ListItem item, Color isDarkMode, Color textColor) {
    return Card(
      elevation: 5,
      shadowColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Undangan Pernikahan",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDarkMode,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Dengan memohon rahmat dan ridho Allah SWT, kami bermaksud menyelenggarakan pernikahan kami:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "${_parentItem!.namapria} & ${_parentItem!.namawanita}",
                    style: GoogleFonts.josefinSans(
                      textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(height: 12),
                  QrImage(
                    data: item.gambar,
                    version: QrVersions.auto,
                    size: 165.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.deepPurple),
            SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, "Tanggal",
                _formatDate(_parentItem!.tanggal), isDarkMode),
            _buildInfoRow(
                Icons.access_time, "Akad", _parentItem!.akad, isDarkMode),
            _buildInfoRow(
                Icons.access_time, "Resepsi", _parentItem!.resepsi, isDarkMode),
            _buildInfoRow(
                Icons.location_on, "Lokasi", _parentItem!.lokasi, isDarkMode),
            SizedBox(height: 8),
            Divider(color: Colors.deepPurple),
            SizedBox(height: 1),
            _buildGuestInfo(item, isDarkMode, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: isDarkMode),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInfo(ListItem item, Color isDarkMode, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity, // Membuat box memenuhi lebar layar
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Mengubah posisi bayangan
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yth.',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 4),
            Text(
              item.nama,
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 8),
            Text(
              "${item.kota}, ${item.alamat}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            Text(
              "Kecamatan ${item.kecamatan}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            Text(
              "Keluarga bpk/ibu ${item.keluarga ?? 'Tidak tersedia'}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAllInvitations() async {
    print("Downloading all invitations...");
    // Check and request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text("Downloading..."),
                ],
              ),
            ),
          );
        },
      );

      try {
        final directory = Directory('/storage/emulated/0/Download');
        final zipFile =
            File("${directory!.path}/Invitations-${_parentItem!.title}.zip");
        final encoder = ZipEncoder();
        final archive = Archive();

        for (int i = 0; i < _childrenItems.length; i++) {
          final item = _childrenItems[i];
          final key = _boundaryKeys[i];

          // Render the boundary to an image
          await Future.delayed(
              Duration(milliseconds: 100)); // Ensure the widget is rendered
          final imageBytes = await _capturePng(key);

          final fileName =
              "invitation_${i + 1}.png"; // Use index as temporary ID
          final archiveFile =
              ArchiveFile(fileName, imageBytes.length, imageBytes);
          archive.addFile(archiveFile);
        }

        final zipData = encoder.encode(archive);
        await zipFile.writeAsBytes(zipData!);

        // Close loading dialog
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'All invitations downloaded successfully at ${directory.path}!')),
        );
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();

        print("Error downloading invitations: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download invitations')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Storage permission is required to download the invitations')),
      );
    }
  }

  Future<Uint8List> _capturePng(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
