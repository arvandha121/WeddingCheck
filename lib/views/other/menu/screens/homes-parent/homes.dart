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
          content: Text('Apakah kamu yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Iya', style: TextStyle(color: Colors.red)),
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Data Tidak Ditemukan",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            );
          } else if (snapshot.hasData) {
            final parents = snapshot.data!;
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  alignment: Alignment.center,
                  child: Text(
                    "List Berkas",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: parents.length,
                    itemBuilder: (context, index) {
                      final item = parents[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 2.0,
                                ),
                                child: Text(
                                  '${item.namapria} & ${item.namawanita}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ketuk untuk melihat detail',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              )
                            ],
                          ),
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
                                builder: (context) =>
                                    HomesChild(parentId: item.id!),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
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
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
