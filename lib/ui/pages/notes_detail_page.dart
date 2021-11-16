import '../../db/note_database.dart';
import '../../model/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_add_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);
  final int noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });

    note = await NoteDatabase.instance.readNote(widget.noteId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    note.noteTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    DateFormat.yMMMEd().format(note.createdTime),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    note.noteDescription,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ));
  }

  Widget deleteButton() => IconButton(
      onPressed: () async {
        await NoteDatabase.instance.deleteNote(widget.noteId);
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.delete));

  Widget editButton() => IconButton(
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EditAddNotePage(note: note)))
            .then((_) async {
          setState(() {
            refreshNote();
          });
        });
      },
      icon: const Icon(Icons.edit));
}
