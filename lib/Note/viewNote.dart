import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waelfirebase/Note/addNote.dart';
import 'package:waelfirebase/Note/editNote.dart';
import 'package:waelfirebase/categories/edit.dart';
import 'package:waelfirebase/constants/constants.dart';

class ViewNote extends StatefulWidget {
  final String categoryId;
  const ViewNote({super.key, required this.categoryId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('notes')
        // .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AddNote(categoryId: widget.categoryId),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homePage, (route) => false);
            },
          ),
          title: const Text('Notes'),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.of(context)
                            .pushNamedAndRemoveUntil(login, (route) => false),
                      );
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => EditNote(
                          categoryId: widget.categoryId,
                          noteId: data[index].id,
                          oldName: data[index]["note"],
                        ),
                      ),
                    ),
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Delete',
                        desc: 'What do u want?',
                        // btnOkOnPress: () async {
                        //   // Navigator.of(context).push(
                        //   //   MaterialPageRoute(
                        //   //     builder: (context) => EditCategory(
                        //   //       docId: data[index].id,
                        //   //       oldName: data[index]['name'],
                        //   //     ),
                        //   //   ),
                        //   // );
                        // },
                        // btnOkText: 'Update',
                        btnCancelText: 'Delete',
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(widget.categoryId)
                              .collection('notes')
                              .doc(data[index].id)
                              .delete()
                              .then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewNote(
                                        categoryId: widget.categoryId)));
                            //todo I can't put setstate instead Navigator
                          });
                        },
                        btnOkColor: Colors.orange,
                      ).show();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Image.asset(
                            //   'assets/images/folder.png',
                            //   height: 100,
                            // ),
                            Text("${data[index]['note']}")
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
