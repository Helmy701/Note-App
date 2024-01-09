import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:waelfirebase/Screens/notes/add_note.dart';
import 'package:waelfirebase/Screens/notes/edit_note.dart';
import 'package:waelfirebase/constants/constants.dart';
import 'package:waelfirebase/model/note_model.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key, required this.categoryId});

  final String categoryId;

  // List<QueryDocumentSnapshot> data = [];

  late CollectionReference notes = FirebaseFirestore.instance
      .collection(kCategoriesCollection)
      .doc(categoryId)
      .collection(kNotesCollection);

  // getData() async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddNote(categoryID: categoryId),
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
        body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: notes.orderBy(kTime).snapshots(),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasData) {
              List<NoteModel> notesList = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                notesList.add(NoteModel.fromJson(snapshot.data!.docs[i]));
              }
              print(notesList.length);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  // itemCount: snapshot.data!.docs.length,
                  itemCount: notesList.length,

                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) {
                        // notes.doc(snapshot.data!.docs[index].id).delete().then(
                        notes.doc(notesList[index].noteID).delete().then(
                          (value) {
                            print("Delete successful");
                          },
                        ).catchError(
                          (e) {
                            print("Error is $e");
                          },
                        );
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 35),
                      ),
                      // key: Key(snapshot.data!.docs[index].id),
                      key: Key(notesList[index].noteID),

                      child: Card(
                        elevation: 5,
                        // shadowColor: const Color.fromARGB(103, 255, 153, 0),

                        margin: const EdgeInsets.symmetric(vertical: 10),

                        // decoration: BoxDecoration(
                        //     gradient: const RadialGradient(
                        //       colors: [Color(0xFF6034A6), Color(0xFF4833A6)],
                        //       radius: 2.5,
                        //     ),
                        //     borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNote(
                                      noteID: snapshot.data!.docs[index]
                                          [kNotesID],
                                      oldTitle: snapshot.data!.docs[index]
                                          [kNotesTitle],
                                      oldCotent: snapshot.data!.docs[index]
                                          [kNotesContent],
                                      categoryID: categoryId,
                                    )));
                          },
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 5, 15, 5),
                          leading: const Icon(Icons.note,
                              color: Color(0xFF0F0F1E), size: 50),
                          // title: Text("${snapshot.data!.docs[index]["title"]}",
                          title: Text(notesList[index].title,
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          subtitle: SizedBox(
                            width: 200,
                            child: Text(
                              // "${snapshot.data!.docs[index]["content"]}",
                              notesList[index].content,

                              style: const TextStyle(
                                  color: Color(0xFFAEAEB3), fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error.. Try Again Later",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              );
            }
            return const Center(
              child: Text(
                "Write It Down Before You Forget It",
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            );
            // return Container();
          },
        )
        // : GridView.builder(
        // itemCount: data.length,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   mainAxisExtent: 160,
        // ),
        // itemBuilder: (context, index) {
        // return InkWell(
        //   onTap: () => Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => EditNote(
        //         categoryId: widget.categoryId,
        //         noteId: data[index].id,
        //         oldName: data[index]["note"],
        //       ),
        //     ),
        //   ),
        //   onLongPress: () {
        //     AwesomeDialog(
        //       context: context,
        //       dialogType: DialogType.error,
        //       animType: AnimType.rightSlide,
        //       title: 'Delete',
        //       desc: 'What do u want?',
        //       // btnOkOnPress: () async {
        //       //   // Navigator.of(context).push(
        //       //   //   MaterialPageRoute(
        //       //   //     builder: (context) => EditCategory(
        //       //   //       docId: data[index].id,
        //       //   //       oldName: data[index]['name'],
        //       //   //     ),
        //       //   //   ),
        //       //   // );
        //       // },
        //       // btnOkText: 'Update',
        //       btnCancelText: 'Delete',
        //       btnCancelOnPress: () async {
        //         await FirebaseFirestore.instance
        //             .collection('categories')
        //             .doc(widget.categoryId)
        //             .collection('notes')
        //             .doc(data[index].id)
        //             .delete()
        //             .then((value) {
        //           Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => NoteScreen(
        //                       categoryId: widget.categoryId)));
        //           //todo I can't put setstate instead Navigator
        //         });
        //       },
        //       btnOkColor: Colors.orange,
        //     ).show();
        //   },
        //   child: Card(
        //     child: Padding(
        //       padding: const EdgeInsets.all(20.0),
        //       child: Column(
        //         children: [
        //           // Image.asset(
        //           //   'assets/images/folder.png',
        //           //   height: 100,
        //           // ),
        //           Text("${data[index]['note']}")
        //         ],
        //       ),
        //     ),
        //   ),
        // );
        // },
        );
  }
}
