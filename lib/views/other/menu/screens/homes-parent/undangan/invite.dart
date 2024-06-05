import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitationPage extends StatefulWidget {
  final int parentId;
  final int guestId;

  const InvitationPage(
      {Key? key, required this.parentId, required this.guestId})
      : super(key: key);

  @override
  _InvitationPageState createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  ParentListItem? _parentItem;
  late ListItem _listItem;
  List<ListItem> _childrenItems = [];
  bool _isLoading = true;
  String _selectedFormat = 'Digital'; // Default format
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadInvitationData();
      _loadData();
    });
  }

  Future<void> _loadInvitationData() async {
    final data = await DatabaseHelper().getInvitationData(widget.parentId);
    setState(() {
      _parentItem = data['parent'];
      _childrenItems = data['children'];
      _isLoading = false;
    });
  }

  void _loadData() async {
    try {
      ListItem? item = await DatabaseHelper().getListItem(widget.guestId);
      if (item != null) {
        setState(() {
          _listItem = item;
          // Set the format based on the nohp value
          _selectedFormat = item.nohp == "-" ? 'Fisik' : 'Digital';
        });
      } else {
        print("Guest not found");
      }
    } catch (e) {
      print("Failed to load guest data: $e");
    }
  }

  String _formatDate(String date) {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = inputFormat.parse(date);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    Color isDarkMode = Theme.of(context).brightness == Brightness.dark
        ? Colors.yellow
        : Colors.deepPurple;
    bool isDarkModes = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkModes ? Colors.black : Colors.black;
    Color qrForegroundColor = isDarkModes ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text('Undangan Pernikahan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFormatSelector(),
                  SizedBox(height: 16),
                  _parentItem != null
                      ? _selectedFormat == 'Fisik'
                          ? Column(
                              children: [
                                _buildPhysicalInvitationCard(
                                  isDarkMode,
                                  textColor,
                                  qrForegroundColor,
                                ),
                                SizedBox(
                                  height: 20,
                                ), // Spacing before the button
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _downloadInvitation,
                                    child: Text('Unduh Undangan'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildDigitalInvitationCard(
                                    isDarkMode, qrForegroundColor),
                                SizedBox(
                                  height: 18,
                                ), // Spacing before the button
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _shareInvitation,
                                    child: Text('Bagikan Undangan'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (_listItem.nohp != "-")
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _shareViaWhatsApp,
                                      child: Text('Kirim via WhatsApp'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                      : Container(),
                ],
              ),
            ),
    );
  }

  Widget _buildFormatSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // This will make the container expand to fill the row
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true, // Makes the dropdown itself expand
                  value: _selectedFormat,
                  items: <String>['Digital', 'Fisik'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFormat = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInvitationCard(
      Color isDarkMode, Color textColor, Color qrForegroundColor) {
    return Screenshot(
      controller: screenshotController,
      child: Card(
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
                      data: _listItem.gambar,
                      version: QrVersions.auto,
                      size: 165.0,
                      foregroundColor: qrForegroundColor,
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
              _buildInfoRow(Icons.access_time, "Resepsi", _parentItem!.resepsi,
                  isDarkMode),
              _buildInfoRow(
                  Icons.location_on, "Lokasi", _parentItem!.lokasi, isDarkMode),
              SizedBox(height: 8),
              Divider(color: Colors.deepPurple),
              SizedBox(height: 1),
              _buildGuestInfo(widget.guestId, isDarkMode, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalInvitationCard(
      Color isDarkMode, Color qrForegroundColor) {
    return Screenshot(
      controller: screenshotController,
      child: Card(
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
                      data: _listItem.gambar,
                      version: QrVersions.auto,
                      size: 180.0,
                      foregroundColor: qrForegroundColor,
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
              _buildInfoRow(Icons.access_time, "Resepsi", _parentItem!.resepsi,
                  isDarkMode),
              _buildInfoRow(
                  Icons.location_on, "Lokasi", _parentItem!.lokasi, isDarkMode),
              SizedBox(height: 8),
            ],
          ),
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

  Widget _buildGuestInfo(int id, Color isDarkMode, Color textColor) {
    // Assuming _childrenItems is a list of ListItem and contains all necessary guest information
    ListItem? guestInfo = _childrenItems.firstWhere(
      (item) => item.id == id,
    );

    if (guestInfo == null) {
      return Text('Guest information is not available',
          style: TextStyle(color: textColor));
    }

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
              guestInfo.nama,
              style: GoogleFonts.lato(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 8),
            Text(
              "${guestInfo.kota}, ${guestInfo.alamat}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            Text(
              "Kecamatan ${guestInfo.kecamatan}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            Text(
              "Keluarga bpk/ibu ${guestInfo.keluarga ?? 'Tidak tersedia'}",
              style: GoogleFonts.lato(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (!result.isGranted) {
        // Handle the case when permission is denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Storage permission is required to download the invitation')),
        );
      }
    }
  }

  Future<void> _downloadInvitation() async {
    // Check and request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Capture the screenshot only if permissions are granted
      screenshotController.capture().then((Uint8List? image) {
        if (image != null) {
          saveScreenshot(image);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to capture the screenshot')),
          );
        }
      }).catchError((error) {
        print("Error capturing screenshot: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing the screenshot')),
        );
      });
    } else {
      // Handle the case when permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Storage permission is required to download the invitation')),
      );
    }
  }

  Future saveScreenshot(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "Undangan-$time";
    await ImageGallerySaver.saveImage(bytes, name: name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation downloaded to your device!')),
    );
  }

  void _shareInvitation() async {
    final directory =
        await getTemporaryDirectory(); // Using a temporary directory
    final imagePath = await screenshotController.captureAndSave(directory.path,
        fileName: "invitation.png");

    if (imagePath != null) {
      await Share.shareFiles([imagePath],
          text:
              'Anda diundang ke Pernikahan ${_parentItem!.namapria} & ${_parentItem!.namawanita}, yang akan berlangsung pada ${_formatDate(_parentItem!.tanggal)} di ${_parentItem!.lokasi}.\nKami berharap Anda dapat bergabung dalam perayaan cinta dan kebahagiaan kami.');
    } else {
      print("Failed to capture screenshot");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share the invitation')),
      );
    }
  }

  void _shareViaWhatsApp() async {
    // Periksa apakah _parentItem dan _listItem tidak null
    if (_parentItem == null || _listItem.nohp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Data tidak lengkap untuk mengirim undangan via WhatsApp')),
      );
      return;
    }

    // Periksa apakah semua properti yang diperlukan tidak null
    if (_parentItem!.namapria == null ||
        _parentItem!.namawanita == null ||
        _parentItem!.tanggal == null ||
        _parentItem!.lokasi == null ||
        _listItem.nohp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Data tidak lengkap untuk mengirim undangan via WhatsApp')),
      );
      return;
    }

    final message = 'Halo ${_listItem.nama}.';
    // final message =
    //     'Anda diundang ke Pernikahan ${_parentItem!.namapria} & ${_parentItem!.namawanita}, yang akan berlangsung pada ${_formatDate(_parentItem!.tanggal)} di ${_parentItem!.lokasi}.\nKami berharap Anda dapat bergabung dalam perayaan cinta dan kebahagiaan kami.';
    final url =
        'https://wa.me/${_listItem.nohp}?text=${Uri.encodeComponent(message)}';

    print('WhatsApp URL: $url'); // Debugging statement

    // ignore: deprecated_member_use
    if (!await launch(url)) {
      print('Could not launch WhatsApp'); // Debugging statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}
