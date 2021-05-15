import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save note',
            // disable on empty
            onPressed:
                note == null || note.trim().isEmpty ? null : addNoteAndGoBack,
          ),
        ],
      ),
      body: Container(
        child: TextField(
          autocorrect: true,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Title',
          ),
          onChanged: (value) => {
            setState(() {
              note = value;
            })
          },
        ),
        margin: EdgeInsets.fromLTRB(18, 4, 18, 18),
      ),
    );
  }

  addNoteAndGoBack() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> items;
    if (prefs.containsKey(storageItemsKey)) {
      items = prefs.getStringList(storageItemsKey);
    } else {
      items = [];
    }
    items.add(note);
    prefs.setStringList(storageItemsKey, items);
    Navigator.pop(context);
  }
}
