import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqlite/model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({Key? key, required this.note, required this.index}) : super(key: key);
  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    List<Color> colorContainer = [
      Colors.pink.shade300,
      Colors.blue.shade400,
      Colors.purple.shade300,
    ];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorContainer[note.chooseColorIndex],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMEd().format(note.createdTime),
            style: TextStyle(color: Colors.blueGrey.shade900),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            note.noteTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
