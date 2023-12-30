import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/Note/viewNote.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';

class EditNote extends StatefulWidget {
  final String categoryId;
  final String noteId;
  final String oldName;
  const EditNote(
      {super.key,
      required this.categoryId,
      required this.noteId,
      required this.oldName});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  bool isLoading = false;

  editNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes');
    try {
      isLoading = true;
      setState(() {});
      await notes.doc(widget.noteId).update({
        "note": note.text,
      }).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ViewNote(categoryId: widget.categoryId)),
        );
        // Navigator.of(context).pop();
        isLoading = false;
        return value;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    note.text = widget.oldName;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    child: CustomTextFormADD(
                      hintText: 'enter note',
                      myController: note,
                      validator: (val) {
                        if (val == null) {
                          return "can't be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  CustomButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          editNote();
                        }
                      },
                      title: 'Save'),
                ],
              )),
    );
  }
}
