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
      backgroundColor: Colors.deepPurple,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
