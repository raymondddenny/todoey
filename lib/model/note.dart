const String tableNotes = 'notes';

class NoteFields {
  // all columns
  static final List<String> values = [
    /// add all fields
    id, noteTitle, noteDescription, chooseColorIndex, createdTime
  ];
  static const String id = "_id";
  static const String noteTitle = "noteTitle";
  static const String noteDescription = "noteDescription";
  static const String createdTime = "createdTime";
  static const String chooseColorIndex = "chooseColor";
}

class Note {
  final int? id;
  final String noteTitle;
  final String noteDescription;
  final DateTime createdTime;
  final int chooseColorIndex;

  const Note({
    this.id,
    required this.noteDescription,
    required this.createdTime,
    required this.noteTitle,
    required this.chooseColorIndex,
  });

  Note copyWith({int? id, String? noteTitle, String? noteDescription, DateTime? createdTime, int? chooseColorIndex}) =>
      Note(
        id: id ?? this.id,
        noteDescription: noteDescription ?? this.noteDescription,
        createdTime: createdTime ?? this.createdTime,
        noteTitle: noteTitle ?? this.noteTitle,
        chooseColorIndex: chooseColorIndex ?? this.chooseColorIndex,
      );

  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.noteTitle: noteTitle,
      NoteFields.noteDescription: noteDescription,
      NoteFields.createdTime: createdTime.toIso8601String(),
      NoteFields.chooseColorIndex: chooseColorIndex
    };
  }

  factory Note.fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        noteTitle: json[NoteFields.noteTitle] as String,
        noteDescription: json[NoteFields.noteDescription] as String,
        createdTime: DateTime.parse(json[NoteFields.createdTime] as String),
        chooseColorIndex: json[NoteFields.chooseColorIndex] as int,
      );
}
