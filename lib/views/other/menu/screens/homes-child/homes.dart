import 'package:flutter/material.dart';
import 'package:weddingcheck/app/model/parentListItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-child/create-form/create.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-child/detail-form/detail.dart';
import 'package:weddingcheck/views/other/menu/screens/homes-child/edit-form/edit.dart';
import 'package:weddingcheck/views/other/menu/screens/scanner/qrscanner.dart';

class HomesChild extends StatefulWidget {
  final int parentId;

  HomesChild({required this.parentId});

  @override
  State<HomesChild> createState() => _HomesChildState();
}

class _HomesChildState extends State<HomesChild> {
  late Future<List<ListItem>> childItems;
  TextEditingController _searchController = TextEditingController();
  List<ListItem> _items = [];
  // bool _isLoading = true;

  final DatabaseHelper list = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadItems() async {
    try {
      var items = await list.getChildren(widget.parentId,
          query: _searchController.text);
      print("Fetched items: $items"); // Debugging line
      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  void _onSearchChanged() {
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Tamu"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              right: 12.0,
              left: 12.0,
              bottom: 18.0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Create(parentId: widget.parentId),
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text("DATA KOSONG",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)))
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 18),
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(item: item),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(item.nama,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(item.keterangan,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.amber),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Edits(
                                              item: item,
                                              onEditSuccess: _loadItems),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final shouldDelete =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus item ini?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Tidak'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text(
                                                'Iya',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldDelete == true) {
                                        await DatabaseHelper()
                                            .deleteListItem(item.id ?? 0);
                                        setState(() {
                                          _items.removeAt(index);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
