import 'package:waelfirebase/constants/constants.dart';

class NoteModel {
  final String noteID;
  final String title;
  final String content;
  // final String categoryID;

  NoteModel({
    required this.noteID,
    required this.title,
    required this.content,
    // required this.categoryID,
  });
  factory NoteModel.fromJson(json) {
    return NoteModel(
      noteID: json[kNotesID],
      title: json[kNotesTitle],
      content: json[kNotesContent],
      // categoryID: json[kCategoryID],
    );
  }
}
