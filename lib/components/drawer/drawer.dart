import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waelfirebase/components/drawer/setting.dart';

// ignore: must_be_immutable
class Mydrawer extends StatelessWidget {
  late String myUsername, myEmail, myPassword, myId;
  Mydrawer(String username, String email, String password, String id,
      {super.key}) {
    myUsername = username;
    myEmail = email;
    myPassword = password;
    myId = id;
  }
  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? img = prefs.getString("avatar");
    Uint8List bytes = base64Decode(img!);
    return Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: Colors.orange,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
            decoration: const BoxDecoration(color: Color(0xFF0F0F1E)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 40,
                  child: Container(
                      width: 75,
                      height: 75,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0F0F1E),
                          borderRadius: BorderRadius.circular(360)),
                      child: FutureBuilder(
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myUsername,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          width: 175,
                          child: Text(myEmail,
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              )))
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: const Text("Notes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Divider(
                  color: Color(0xFF0F0F1E),
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.border_color_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: const Text("Add Note",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pushNamed("AddNote");
                  },
                ),
                const Divider(
                  color: Color(0xFF0F0F1E),
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: const Text("Setting",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Setting(
                              id: myId,
                              username: myUsername,
                              email: myEmail,
                              password: myPassword,
                            )));
                  },
                ),
                const Divider(
                  color: Color(0xFF0F0F1E),
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.handshake_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: const Text("Help",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).pushNamed("Help");
                  },
                ),
                const Divider(
                  color: Color(0xFF0F0F1E),
                  indent: 15,
                  endIndent: 15,
                  thickness: 2,
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F0F1E),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: const Text("Log Out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF0F0F1E),
                          title:
                              const Text("Are you sure you want to Logout ?"),
                          titleTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          titlePadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          icon: const Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.red,
                            size: 60,
                          ),
                          iconPadding:
                              const EdgeInsets.fromLTRB(10, 20, 10, 10),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.red,
                                  width: 4,
                                  strokeAlign: BorderSide.strokeAlignInside),
                              borderRadius: BorderRadius.circular(25)),
                          actionsPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context)
                                    .pushReplacementNamed("SplashScreen");
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(135, 40),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Text("Yes",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(135, 40),
                                  backgroundColor: const Color(0xFF0F0F1E),
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.red,
                                          width: 3,
                                          strokeAlign:
                                              BorderSide.strokeAlignInside),
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Text("No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
