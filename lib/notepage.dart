import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NoteEditor extends StatefulWidget {
  final Map? note;
  final int? index;
  final bool isNew;

  const NoteEditor({this.note, this.index, required this.isNew, super.key});

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late DateTime createdAt;
  late DateTime updatedAt;

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      _titleController.text = widget.note!['title'];
      _contentController.text = widget.note!['content'];
      createdAt = DateTime.parse(widget.note!['createdAt']);
      updatedAt = DateTime.parse(widget.note!['updatedAt']);
    } else {
      createdAt = DateTime.now();
      updatedAt = DateTime.now();
    }
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      // Tampilkan pesan error jika judul atau konten kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title and content can't be empty!"),
        ),
      );
      return;
    }
    final title = _titleController.text;
    final content = _contentController.text;
    final formattedCreatedAt =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);
    final formattedUpdatedAt = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.now()); // Update updatedAt

    final Map<String, dynamic> note = {
      'title': title,
      'content': content,
      'createdAt': formattedCreatedAt,
      'updatedAt': formattedUpdatedAt,
    };

    final notesBox = Hive.box<Map>('notes');

    try {
      if (widget.isNew) {
        await notesBox.add(note);
      } else {
        await notesBox.putAt(widget.index!, note);
      }

      Navigator.pop(context,
          note); // Kembali ke halaman sebelumnya dengan membawa data catatan yang disimpan
    } catch (e) {
      // Tangani kesalahan jika ada
      print("Error saving note: $e");
      // Tambahkan log atau notifikasi error sesuai kebutuhan
    }
  }

  void _deleteNote() async {
    if (!widget.isNew) {
      final notesBox = Hive.box<Map>('notes');
      try {
        await notesBox.deleteAt(widget.index!);
        Navigator.pop(context);
      } catch (e) {
        print("Error deleting note: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 15, 43, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: _deleteNote,
          ),
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!widget.isNew) ...[
              Text(
                DateFormat('dd-MM-yyyy HH:mm').format(createdAt),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.white60),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "Content",
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
