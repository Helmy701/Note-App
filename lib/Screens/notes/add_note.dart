import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waelfirebase/Screens/notes/note_screen.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String categoryID;
  const AddNote({super.key, required this.categoryID});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  // String? urlGallary;
  // String? urlCamera;
  // List url = [];
  late String noteID;
  bool isLoading = false;
  File? cameraPhoto;
  File? gallaryPhoto;

//   getCameraPhoto() async {
//     final ImagePicker picker = ImagePicker();
// // Pick an image.
//     // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // Capture a photo.
//     final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {}
//     cameraPhoto = File(photo!.path);
//     var photoName = basename(photo.path);
//     var refStorage = FirebaseStorage.instance.ref('images/$photoName');
//     await refStorage.putFile(cameraPhoto!);
//     urlCamera = await refStorage.getDownloadURL();
//     url.add(urlCamera);

//     setState(() {});
//   }

  createNoteId() {
    String firstRandom = Random().nextInt(99999).toString();
    String secondRandom = Random().nextInt(99999).toString();
    noteID = "${firstRandom}Helmy$secondRandom";
  }

//   getGallaryPhoto() async {
//     final ImagePicker picker = ImagePicker();
// // Pick an image.
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // Capture a photo.
//     // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       gallaryPhoto = File(image.path);
//       var photoName = basename(image.path);
//       var refStorage = FirebaseStorage.instance.ref('images').child(photoName);
//       await refStorage.putFile(gallaryPhoto!);
//       urlGallary = await refStorage.getDownloadURL();
//       url.add(urlGallary);
//     }
//     setState(() {});

//   }
  @override
  void initState() {
    // TODO: implement initState
    createNoteId();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    addNote() async {
      CollectionReference notes = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryID)
          .collection('notes');
      try {
        isLoading = true;
        setState(() {});
        await notes.add({
          "note": contentController.text,
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    NoteScreen(categoryId: widget.categoryID)),
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Note',
          ),
          actions: [
            MediaQuery.of(context).viewInsets.bottom != 0
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
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
                                        color:
                                            Color.fromARGB(255, 109, 108, 106),
                                        fontSize: 17),
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
                        notes.doc(noteID).set({
                          kNotesTitle: titleController.text,
                          kNotesContent: contentController.text,
                          kNotesID: noteID,
                          kTime: DateTime.now(),
                        });
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    title: 'Add',
                  ),
                ],
              ),
      ),
    );
  }
}
