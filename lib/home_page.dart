import 'package:flutter/material.dart';
import 'package:notes/add_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> items;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add note',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNotePage()),
                );
                setState(() {
                  isLoading = true;
                });
                loadItems();
                setState(() {
                  isLoading = false;
                });
              }),
        ],
      ),
      body: getBody(),
    );
  }

  @override
  initState() {
    super.initState();
    isLoading = true;
    loadItems();
  }

  void loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    if (prefs.containsKey(storageItemsKey))
      list = prefs.getStringList(storageItemsKey);
    setState(() {
      this.items = list;
      isLoading = false;
    });
  }

  getBody() {
    if (isLoading == true || isLoading == null)
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      if (items.isEmpty) {
        return Center(child: Text("Notes list empty"));
      } else
        return ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          itemBuilder: (context, index) {
            return PopupMenuButton(
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.notes),
                  title: Text(items[index]),
                ),
              ),
              onSelected: (e) {
                var item = items[e];
                removeItem(e);
                setState(() {});
                final snackBar = SnackBar(
                  content: Text("'$item' removed"),
                  action: SnackBarAction(
                    label: 'Dissmiss',
                    textColor: Colors.yellow,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              itemBuilder: (context) {
                return <PopupMenuItem>[
                  new PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                    value: index,
                  ),
                ];
              },
            );
          },
        );
    }
  }

  void removeItem(int index) async {
    items.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(storageItemsKey, items);
  }
}
