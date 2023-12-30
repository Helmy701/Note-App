import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                            await categories.add({
                              "name": name.text,
                              "id": FirebaseAuth.instance.currentUser!.uid,
                              // "time": DateTime.now,
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
    );
  }
}
