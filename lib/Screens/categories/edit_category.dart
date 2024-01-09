import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/text_form_field_add.dart';
import 'package:waelfirebase/constants/constants.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.docId, required this.oldName});
  final String docId;
  final String oldName;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
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
                            // await categories
                            //     .doc(widget.docId)
                            //     .update({"name": name.text}).then((value) {
                            //   Navigator.of(context).pushNamedAndRemoveUntil(
                            //       homePage, (route) => false);
                            //   isLoading = false;
                            //   return value;
                            // });
                            await categories.doc(widget.docId).set(
                                {kCategoryName: name.text},
                                SetOptions(merge: true)).then((value) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  homePage, (route) => false);
                              isLoading = false;
                              return value;
                            });
                            //Set = Add(if doc not found) + Update
                            //merge = false >> field delete
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Error $e');
                          }
                        }
                      },
                      title: 'Update'),
                ],
              )),
    );
  }
}
