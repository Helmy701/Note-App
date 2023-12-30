import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waelfirebase/Note/viewNote.dart';
import 'package:waelfirebase/categories/edit.dart';
import 'package:waelfirebase/constants/constants.dart';

class HomePage extends StatefulWidget {
  // final String docId;
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        // .orderBy('time')
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
                itemCount: data.length,
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
                              builder: (context) =>
                                  ViewNote(categoryId: data[index].id)));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: data[index]['name'],
                        desc: 'What do u want?',
                        btnOkOnPress: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditCategory(
                                docId: data[index].id,
                                oldName: data[index]['name'],
                              ),
                            ),
                          );
                        },
                        btnOkText: 'Update',
                        btnCancelText: 'Delete',
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(data[index].id)
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
                            Text("${data[index]['name']}")
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
