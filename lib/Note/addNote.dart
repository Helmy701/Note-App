import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waelfirebase/Note/viewNote.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({super.key, required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  File? cameraPhoto;
  getCameraPhoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    cameraPhoto = File(photo!.path);
    setState(() {});
  }

  getGallaryPhoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      cameraPhoto = File(image!.path);
    }
    setState(() {});
  }

  addNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes');
    try {
      isLoading = true;
      setState(() {});
      await notes.add({
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

  bool isLoading = false;
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
        title: const Text('Add Note'),
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
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Add photo',
                          desc: 'Take a Photo or pick from gallary',
                          btnOkOnPress: () async {
                            await getCameraPhoto();
                          },
                          btnOkText: 'Take a Photo',
                          btnCancelText: 'Gallery',
                          btnCancelOnPress: () {},
                          btnOkColor: Colors.orange,
                        ).show();
                      },
                      title: 'Add Image'),
                  CustomButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        addNote();
                      }
                    },
                    title: 'Add',
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (cameraPhoto != null) {
                          Image.file(cameraPhoto!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
