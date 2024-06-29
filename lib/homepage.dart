import 'package:ambw_uas_c14210125/changepasword.dart';
import 'package:ambw_uas_c14210125/notepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _notesBox = Hive.box<Map>('notes');

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteEditor(
          isNew: true,
        ),
      ),
    );
  }

  void _editNote(Map note, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditor(
          note: note,
          index: index,
          isNew: false,
        ),
      ),
    );
  }

  void _deleteNote(int index) {
    _notesBox.deleteAt(index);
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(parsedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
        title: const Text(
          "Tickle Notes",
          style: TextStyle(color: Color.fromRGBO(229, 208, 248, 1)),
        ),
        shadowColor: Colors.black,
        elevation: 10, // Menambahkan shadow dengan elevasi 8
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePIN()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _notesBox.listenable(),
        builder: (context, Box<Map> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No notes available", style: TextStyle(color: Colors.white60)));
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index)!;
              return ListTile(
                title: Text(
                  note['title'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  _formatDateTime(note['updatedAt']),
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => _editNote(note, index),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteNote(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
        shape:
            CircleBorder(), // Menggunakan CircleBorder untuk membuat bentuk lingkaran
      ),
    );
  }
}
