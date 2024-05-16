import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:weddingcheck/app/provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Wedding Check"),
      actions: [
        Consumer<UiProvider>(
          builder: (context, UiProvider notifier, child) {
            return IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Ingin keluar dari aplikasi?",
                  textConfirm: "Iya",
                  textCancel: "Tidak",
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.black,
                  onConfirm: () {
                    notifier.logout(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logout berhasil'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.logout,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
