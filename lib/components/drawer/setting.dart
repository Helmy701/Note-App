import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waelfirebase/components/drawer/cardInfo.dart';

// ignore: must_be_immutable
class Setting extends StatefulWidget {
  late String username;
  late String email;
  late String password;
  late String id;
  Setting(
      {required this.username,
      required this.email,
      required this.password,
      required this.id,
      super.key});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  File? imageFile;
  late Reference refStorage;
  ImagePicker imagePicker = ImagePicker();

  deleteUAccount() async {
    CollectionReference delAccountData =
        FirebaseFirestore.instance.collection("users");
    await delAccountData.doc("$widget.id").delete().then((value) {
      print("Delete users Info Successfully");
    }).catchError((e) {
      print("Error = $e");
    });

    CollectionReference delAccountNotes =
        FirebaseFirestore.instance.collection("notes");
    await delAccountNotes.doc("$widget.id").delete().then((value) {
      print("Delete Notes Successfully");
    }).catchError((e) {
      print("Error = $e");
    });

    Reference delImage = FirebaseStorage.instance.ref("Assets/$widget.id");
    await delImage.delete().then((value) {
      print("Delete Image Successfully");
    }).catchError((e) {
      print("Error = $e");
    });

    var delAccount = FirebaseAuth.instance.currentUser;
    await delAccount!.delete().then((value) {
      print("Delete Account Successfully");
    }).catchError((e) {
      print("Error = $e");
    });

    Navigator.of(context).pushReplacementNamed("SplashScreen");
  }

  chooseFromCamera(BuildContext context) async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      Navigator.of(context).pop();
    }
  }

  chooseFromGallery(BuildContext context) async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      Navigator.of(context).pop();
    }
  }

  static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString("avatar", base64Image);
  }

  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? img = prefs.getString("avatar");
    Uint8List bytes = base64Decode(img!);
    return Image.memory(bytes);
  }

  saveChanges() async {
    if (imageFile != null) {
      Reference refStorage =
          FirebaseStorage.instance.ref("Assets/${widget.id}/avatarImage");
      await refStorage.putFile(imageFile!);
      String url = await refStorage.getDownloadURL();
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        saveImage(response.bodyBytes);
      } else {
        //TODO: Handle error
      }
    }
  }

  changePicOptions(context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(25),
            height: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              color: Color(0xFF0F0F1E),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () => chooseFromCamera(context),
                      child: const Text("Open Camera",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.orange,
                  thickness: 3,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.photo_album_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () => chooseFromGallery(context),
                      child: const Text("Choose From Gallery",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF6034A6),
          foregroundColor: Colors.white,
          leadingWidth: 150,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child:
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
                ),
                Text("Setting",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      padding: const EdgeInsets.only(top: 30),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      child: CircleAvatar(
                          backgroundColor: const Color(0xFF0F0F1E),
                          radius: 85,
                          child: Container(
                              width: 155,
                              height: 155,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(360)),
                              child: imageFile == null
                                  ? FutureBuilder(
                                      future: getImage(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image(
                                            image: snapshot.data!.image,
                                            fit: BoxFit.cover,
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    )
                                  : Image(
                                      image: FileImage(imageFile!),
                                      fit: BoxFit.cover))),
                    )
                  ],
                ),
              ),
              Container(
                height: 600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => changePicOptions(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_square,
                              color: Colors.orange, size: 30),
                          Text(
                            "Change Picture",
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Info(
                          title: "Username",
                          content: widget.username,
                          show: true,
                        ),
                        Info(title: "Email", content: widget.email, show: true),
                        Info(
                            title: "Password",
                            content: widget.password,
                            show: false),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // await saveChanges();
                              // Navigator.of(context)
                              //     .pushReplacement(MaterialPageRoute(
                              //         builder: (context) => Home(
                              //               id: widget.id,
                              //               username: widget.username,
                              //               email: widget.email,
                              //               password: widget.password,
                              //             )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                minimumSize: const Size(375, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                              onTap: () => deleteUAccount(),
                              child: const Text(
                                "Delete Account",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
