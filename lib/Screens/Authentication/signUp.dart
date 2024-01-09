import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/custom_logo.dart';
import 'package:waelfirebase/components/text_form_field.dart';
import 'package:waelfirebase/constants/constants.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;
    TextEditingController userName = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const CustomLogo(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'SignUp',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'SignUp To Continue Using The App',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "can't to be Empty";
                      }
                      return null;
                    },
                    hintText: 'Enter Your UserName',
                    myController: userName,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "can't to be Empty";
                      }
                      return null;
                    },
                    hintText: 'Enter Your Email',
                    onChange: (data) {
                      email = data;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "can't to be Empty";
                      }
                      return null;
                    },
                    hintText: 'Enter Your Passwor',
                    onChange: (data) {
                      password = data;
                    },
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              title: 'SignUp',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    )
                        .then((value) {
                      value.user!.sendEmailVerification();
                      Navigator.of(context).pushReplacementNamed(login);
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'email-already-in-use',
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print('Not valid');
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(login);
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Have An Account ? "),
                      TextSpan(
                        text: "login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
