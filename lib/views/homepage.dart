import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:weddingcheck/views/other/appbar/appbar.dart';
import 'package:weddingcheck/views/other/menu/bottomnavbar.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-child/homes.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-parent/homes.dart';
import 'package:weddingcheck/views/other/menu/screens/scanner/qrscanner.dart';
import 'package:weddingcheck/views/other/menu/screens/settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListItem> items = [];
  late int selectedIndex;

  List showWidgets = [
    Center(
      child: HomesParent(),
    ),
    Center(
      child: QRScanner(),
    ),
    Center(
      child: Settings(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      // drawer: MyDrawer(),
      body: showWidgets[selectedIndex],
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
