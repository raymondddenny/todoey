import '../../db/note_database.dart';
import '../../model/note.dart';
import 'package:flutter/material.dart';

class EditAddNotePage extends StatefulWidget {
  const EditAddNotePage({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  _EditAddNotePageState createState() => _EditAddNotePageState();
}

class _EditAddNotePageState extends State<EditAddNotePage> {
  final _formKey = GlobalKey<FormState>();
  // late bool isImportant;
  // late int number;
  late String noteTitle;
  late String noteDescription;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initNote();
  }

  Future initNote() async {
    if (widget.note != null) {
      // isImportant = widget.note!.isImportant;
      // number = widget.note!.number;
      noteTitle = widget.note!.noteTitle;
      noteDescription = widget.note!.noteDescription;

      _titleNoteController.text = widget.note!.noteTitle;
      _descriptionNoteController.text = widget.note!.noteDescription;
      selectedIndex = widget.note!.chooseColorIndex;
    } else {
      // isImportant = false;
      // number = 0;
      noteTitle = "";
      noteDescription = "";
    }
  }

  final TextEditingController _titleNoteController = TextEditingController();
  final TextEditingController _descriptionNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [saveButton()],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: NoteColor(
                      index: index,
                      isSelected: selectedIndex == index ? true : false,
                    ),
                  );
                },
              ),
            ),
            TextFormField(
              controller: _titleNoteController,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Title cannot be empty";
                }
              },
              onChanged: (val) {
                if (_titleNoteController.text.isNotEmpty) {
                  _formKey.currentState!.validate();
                }
              },
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.blueGrey,
            ),
            TextFormField(
              controller: _descriptionNoteController,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Description cannot be empty";
                }
              },
              onChanged: (val) {
                setState(() {
                  if (_descriptionNoteController.text.isNotEmpty) {
                    _formKey.currentState!.validate();
                  }
                });
              },
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Type something ...",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveButton() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _descriptionNoteController.text.isNotEmpty
              ? () async {
                  setState(() {
                    noteDescription = _descriptionNoteController.text;
                    noteTitle = _titleNoteController.text;
                  });
                  addOrUpdateNote();
                }
              : null,
          child: const Text("Save"),
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            elevation: 0,
          ),
        ),
      );

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copyWith(
      // isImportant: isImportant,
      chooseColorIndex: selectedIndex,
      noteTitle: noteTitle,
      noteDescription: noteDescription,
    );

    await NoteDatabase.instance.updateNote(note);
  }

  Future addNote() async {
    final note = Note(
      noteDescription: noteDescription,
      createdTime: DateTime.now(),
      noteTitle: noteTitle,
      chooseColorIndex: selectedIndex,
    );

    await NoteDatabase.instance.createNote(note);
  }
}

class NoteColor extends StatelessWidget {
  const NoteColor({
    Key? key,
    this.index = 0,
    this.isSelected = true,
  }) : super(key: key);
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    List<Color> colorContainer = [
      Colors.pink.shade300,
      Colors.blue.shade400,
      Colors.purple.shade300,
    ];
    return Container(
      height: 48,
      width: 48,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colorContainer[index],
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}
