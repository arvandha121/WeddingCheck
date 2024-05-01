import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              width: double.infinity,
              height: 250,
              color: Colors.blue,
              child: Text(
                "Arief Nauvan Ramadha",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Container(
              height: 530,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    onTap: () {
                      print("This is homepage");
                    },
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    subtitle: Text("Beranda"),
                  ),
                  ListTile(
                    onTap: () {
                      print("This is Shop");
                    },
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Shop"),
                    subtitle: Text("Belanja"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
