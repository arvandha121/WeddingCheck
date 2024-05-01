import 'package:flutter/material.dart';
import 'other/drawer/drawer.dart';
import 'other/scanner/camerascan.dart';
import 'other/navbar/bottomnavbar.dart'; // Import MyBottomNavBar class

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedIndex;

  List showWidgets = [
    Center(
      child: Text("Homes"),
    ),
    Center(
      child: CameraScanner(),
    ),
    Center(
      child: Text("Profile"),
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
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
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
