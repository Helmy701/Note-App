import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waelfirebase/Screens/categories/edit_category.dart';
import 'package:waelfirebase/Screens/notes/note_screen.dart';
import 'package:waelfirebase/constants/constants.dart';
import 'package:waelfirebase/model/category_model.dart';

class HomePage extends StatefulWidget {
  // final String docId;
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categoryList = [];
  // List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  // CollectionReference categories =
  //     FirebaseFirestore.instance.collection(kCategoriesCollection);

  // getData() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('categories')
  //       .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       // .orderBy('time')
  //       .get();
  //   data.addAll(querySnapshot.docs);
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(kCategoriesCollection)
        .where(kUserId, isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy(
          kTime,
          descending: false,
        )
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      categoryList.add(
        CategoryModel.fromJson(querySnapshot.docs[i]),
      );
    }
    print(categoryList);

    // data.addAll(querySnapshot.docs);
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
            Navigator.of(context).pushNamed(addCategory);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text('HomePage'),
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
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                itemCount: categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteScreen(
                                  categoryId: categoryList[index].categoryID)));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: categoryList[index].name,
                        desc: 'What do u want?',
                        btnOkOnPress: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditCategory(
                                docId: categoryList[index].categoryID,
                                oldName: categoryList[index].name,
                              ),
                            ),
                          );
                        },
                        btnOkText: 'Update',
                        btnCancelText: 'Delete',
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(categoryList[index].categoryID)
                              .delete()
                              .then((value) {
                            Navigator.pushReplacementNamed(context, homePage);
                            //todo I can't put setstate instead Navigator
                          });
                        },
                        btnOkColor: Colors.orange,
                      ).show();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/folder.png',
                              height: 100,
                            ),
                            Text(categoryList[index].name)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}

// import 'dart:math';

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:waelfirebase/Screens/categories/edit_category.dart';
// import 'package:waelfirebase/Screens/notes/note_screen.dart';
// import 'package:waelfirebase/constants/constants.dart';
// import 'package:waelfirebase/model/category_model.dart';

// class HomePage extends StatefulWidget {
//   // final String docId;
//   const HomePage({
//     super.key,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   CollectionReference categories =
//       FirebaseFirestore.instance.collection(kCategoriesCollection);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.orange,
//           onPressed: () {
//             Navigator.of(context).pushNamed(addCategory);
//           },
//           child: const Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//         ),
//         appBar: AppBar(
//           title: const Text('HomePage'),
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   GoogleSignIn googleSignIn = GoogleSignIn();
//                   googleSignIn.disconnect();
//                   await FirebaseAuth.instance.signOut().then(
//                         (value) => Navigator.of(context)
//                             .pushNamedAndRemoveUntil(login, (route) => false),
//                       );
//                 },
//                 icon: const Icon(Icons.exit_to_app))
//           ],
//         ),
//         body: StreamBuilder<QuerySnapshot<Object?>>(
//             stream: categories
//                 .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                 .orderBy(kTime)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 List<CategoryModel> categoryList = [];

//                 for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                   categoryList
//                       .add(CategoryModel.fromJson(snapshot.data!.docs[i]));
//                 }
//                 return GridView.builder(
//                   itemCount: categoryList.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisExtent: 160,
//                   ),
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => NoteScreen(
//                                     categoryId: categoryList[index].id)));
//                       },
//                       onLongPress: () {
//                         AwesomeDialog(
//                           context: context,
//                           dialogType: DialogType.warning,
//                           animType: AnimType.rightSlide,
//                           title: categoryList[index].name,
//                           desc: 'What do u want?',
//                           btnOkOnPress: () async {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => EditCategory(
//                                   docId: categoryList[index].id,
//                                   oldName: categoryList[index].name,
//                                 ),
//                               ),
//                             );
//                           },
//                           btnOkText: 'Update',
//                           btnCancelText: 'Delete',
//                           btnCancelOnPress: () async {
//                             await FirebaseFirestore.instance
//                                 .collection('categories')
//                                 .doc(categoryList[index].id)
//                                 .delete()
//                                 .then((value) {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => const HomePage()));
//                               //todo I can't put setstate instead Navigator
//                             });
//                           },
//                           btnOkColor: Colors.orange,
//                         ).show();
//                       },
//                       child: Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 'assets/images/folder.png',
//                                 height: 100,
//                               ),
//                               Text(categoryList[index].name)
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else if (snapshot.hasError) {
//                 log(snapshot.error);
//               }
//               return const Center(child: CircularProgressIndicator());
//             }));
//   }
// }
