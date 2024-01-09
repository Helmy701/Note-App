import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/Screens/notes/note_screen.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';

class EditNote extends StatefulWidget {
  final String categoryID;
  final String noteID;
  final String oldTitle;
  final String oldCotent;
  const EditNote({
    super.key,
    required this.categoryID,
    required this.noteID,
    required this.oldTitle,
    required this.oldCotent,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isLoading = false;

  editNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryID)
        .collection('notes');
    try {
      isLoading = true;
      setState(() {});
      await notes.doc(widget.noteID).update({
        kNotesTitle: titleController.text,
        kNotesContent: contentController.text,
      }).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => NoteScreen(categoryId: widget.categoryID)),
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
    titleController.text = widget.oldTitle;
    contentController.text = widget.oldCotent;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    contentController.dispose();
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
          : ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          shadowColor: const Color.fromARGB(151, 255, 153, 0),
                          // shape:,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  maxLength: 65,
                                  maxLines: null,
                                  cursorColor: Colors.orange,
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      fillColor: Colors.white,
                                      focusColor: Colors.orange,
                                      hintText: "title",
                                      counterText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.orange, fontSize: 26),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                                TextFormField(
                                  controller: contentController,
                                  keyboardType: TextInputType.text,
                                  minLines: 10,
                                  maxLines: 13,
                                  cursorColor: Colors.orange,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 109, 108, 106),
                                    fontSize: 17,
                                  ),
                                  decoration: const InputDecoration(
                                      hoverColor: Colors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      fillColor: Colors.white,
                                      focusColor: Colors.orange,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // CustomButton(
                      //   onPressed: () {
                      //     AwesomeDialog(
                      //       context: context,
                      //       dialogType: DialogType.warning,
                      //       animType: AnimType.rightSlide,
                      //       title: 'Upload Image',
                      //       desc: 'Take a Photo or pick from gallary',
                      //       btnOkOnPress: () async {
                      //         await getCameraPhoto();
                      //       },
                      //       btnOkText: 'Take a Photo',
                      //       btnCancelText: 'Gallery',
                      //       btnCancelOnPress: () async {
                      //         await getGallaryPhoto();
                      //       },
                      //       btnOkColor: Colors.orange,
                      //     ).show();
                      //   },
                      //   title: 'Add Image',
                      // ),
                      const SizedBox(
                        height: 10,
                      ),

                      // const Spacer(),
                      // SizedBox(
                      //   height: 100,
                      //   child: ListView.builder(
                      //     itemCount: url.length,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return Image.network(
                      //         url[index],
                      //         height: 100,
                      //       );
                      //       return null;
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                CustomButton(
                  onPressed: () async {
                    if (titleController.text != "" ||
                        contentController.text != "") {
                      CollectionReference notes = FirebaseFirestore.instance
                          .collection(kCategoriesCollection)
                          .doc(widget.categoryID)
                          .collection(kNotesCollection);
                      notes.doc(widget.noteID).update({
                        kNotesTitle: titleController.text,
                        kNotesContent: contentController.text,
                      });
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  title: 'Edit',
                ),
              ],
            ),
    );
  }
}
