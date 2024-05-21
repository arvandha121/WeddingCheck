import 'package:flutter/material.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-child/homes.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-parent/create/create.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-parent/edit/edit.dart';

class HomesParent extends StatefulWidget {
  @override
  State<HomesParent> createState() => _HomesParentState();
}

class _HomesParentState extends State<HomesParent> {
  void onEditSuccess() {
    setState(() {});
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                DatabaseHelper().deleteParentListItem(id);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ParentListItem>>(
        future: DatabaseHelper().getParent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final parents = snapshot.data!;
            return ListView.builder(
              itemCount: parents.length,
              itemBuilder: (context, index) {
                final item = parents[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(item.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tap to see details'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditParents(
                                  item: item,
                                  onEditSuccess: onEditSuccess,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(item.id!),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomesChild(parentId: item.id!),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateParent(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
