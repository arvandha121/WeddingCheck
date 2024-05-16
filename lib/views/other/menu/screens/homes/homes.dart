import 'package:flutter/material.dart';
import 'package:weddingcheck/views/other/menu/screens/homes/create-form/create.dart';
import 'package:weddingcheck/app/database/dbHelper.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/views/other/menu/screens/homes/detail-form/detail.dart';
import 'package:weddingcheck/views/other/menu/screens/homes/edit-form/edit.dart';

class Homes extends StatefulWidget {
  const Homes({Key? key}) : super(key: key);

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  TextEditingController _searchController = TextEditingController();
  List<ListItem> _items = [];
  bool _isLoading = true;

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
      var items = await list.readListItem(query: _searchController.text);
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      print('error list : $e');
    }
  }

  void _onSearchChanged() {
    _loadItems();
  }

  // void _editItem(ListItem item) async {
  //   // Navigate to edit page and wait for the result
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Edits(item: item),
  //     ),
  //   );
  //   // If the edit was successful, reload the items
  //   if (result == true) {
  //     _loadItems();
  //   }
  // }

  void _editItem(ListItem item) async {
    // Navigate to edit page and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edits(
          item: item,
          onEditSuccess: _loadItems, // Pass the callback here
        ),
      ),
    );
    // If the edit was successful, reload the items
    if (result == true) {
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 12.0,
              left: 12.0,
              bottom: 8.0,
            ),
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
          if (!_items
              .isEmpty) // Kondisi untuk menampilkan header hanya jika ada item
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text(
                  "DAFTAR LIST",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _items.isEmpty // Cek apakah list kosong
                    ? Center(
                        child: Text(
                          "DATA KOSONG",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
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
                              child: Container(
                                height: 75,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 18),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.blueAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.nama,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${item.keterangan}",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.amber,
                                      radius: 18,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Edits(
                                                item: item,
                                                onEditSuccess: _loadItems,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 18,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm'),
                                                content: const Text(
                                                  'Yakin untuk menghapus list ini?',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (_items[index].id !=
                                                          null) {
                                                        ListItem deletedItem =
                                                            _items[index];
                                                        int? deletedIndex =
                                                            index;

                                                        int result = await list
                                                            .deleteListItem(
                                                          deletedItem.id!,
                                                        );
                                                        if (result != 0) {
                                                          setState(
                                                            () {
                                                              _items.removeAt(
                                                                  index);
                                                            },
                                                          );

                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "Item deleted",
                                                              ),
                                                              action:
                                                                  SnackBarAction(
                                                                label: "UNDO",
                                                                onPressed:
                                                                    () async {
                                                                  int reAddResult =
                                                                      await list
                                                                          .insertListItem(
                                                                    deletedItem,
                                                                  );
                                                                  if (reAddResult !=
                                                                      0) {
                                                                    setState(
                                                                      () {
                                                                        _items
                                                                            .insert(
                                                                          deletedIndex,
                                                                          deletedItem,
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                seconds: 5,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        print(
                                                            "Error: Item ID is null");
                                                      }
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      // Create atau menambah data listItem
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
