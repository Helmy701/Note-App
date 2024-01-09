import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var time = DateTime.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
  late String CategoryID;
  createCategoryId() {
    String firstRandom = Random().nextInt(99999).toString();
    String secondRandom = Random().nextInt(99999).toString();
    CategoryID = "${firstRandom}Ahmed$secondRandom";
  }

  @override
  void initState() {
    // TODO: implement initState
    createCategoryId();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Category'),
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
                            fontSize: 25,
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
                        hintText: 'enter name',
                        myController: name,
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
                            try {
                              isLoading = true;
                              setState(() {});
                              await categories.doc(CategoryID).set({
                                kCategoryName: name.text,
                                kUserId: FirebaseAuth.instance.currentUser!.uid,
                                kCategoryID: CategoryID,
                                kTime: DateTime.now(),
                              }).then((value) {
                                // Navigator.of(context).pushNamedAndRemoveUntil(
                                //     homePage, (route) => false);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    homePage, (route) => false);
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
                        },
                        title: 'Add'),
                  ],
                )),
      ),
    );
  }
}
