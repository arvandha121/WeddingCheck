import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/provider/provider.dart';
import 'package:weddingcheck/views/auth/loginscreen.dart';
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
            child: Consumer<UiProvider>(builder: (
              context,
              UiProvider notifier,
              child,
            ) {
              return IconButton(
                onPressed: () {
                  // Tambahkan logika untuk keluar (logout) di sini
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Ingin keluar dari aplikasi?",
                    textConfirm: "Iya",
                    textCancel: "Tidak",
                    confirmTextColor: Colors.white,
                    cancelTextColor: Colors.black,
                    onConfirm: () {
                      notifier.logout(context);
                    },
                  );
                },
                icon: Icon(
                  Icons.logout,
                ),
              );
            }),
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
