import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waelfirebase/auth/signup.dart';
import 'package:waelfirebase/components/custom_button.dart';
import 'package:waelfirebase/components/custom_logo.dart';
import 'package:waelfirebase/components/text_form_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:waelfirebase/constants/constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future signInWithGoogle() async {
      isLoading = true;
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      } else {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential).then(
              (value) => Navigator.of(context)
                  .pushNamedAndRemoveUntil(homePage, (route) => false),
            );
      }
    }

    String? email;
    String? password;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Login To Continue Using The App',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                        InkWell(
                          onTap: () async {
                            if (email == null) {
                              return AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please write your email',
                              ).show();
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email!);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'we send email for you. please go to your mail and reset it',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: e.toString(),
                              ).show();
                            }
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            child: const Text(
                              'Forgety Password ?',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    title: 'Login',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          isLoading = true;
                          setState(() {});
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          )
                              .then((value) {
                            isLoading = false;
                            setState(() {});
                            if (value.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed(homePage);
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Please go to your email and verfy it',
                                btnOkOnPress: () => FirebaseAuth
                                    .instance.currentUser!
                                    .sendEmailVerification(),
                                btnOkText: 'Send Code',
                                btnCancelText: 'cancel',
                                btnCancelOnPress: () {},
                                btnOkColor: Colors.orange,
                              ).show();
                            }
                          });
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email',
                            ).show();
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user.',
                            ).show();
                          }
                        }
                      } else {
                        print('Not valid');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textColor: Colors.white,
                    color: Colors.red[700],
                    onPressed: () async {
                      await signInWithGoogle().then((value) {
                        setState(() {});
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Login With Google"),
                        Image.asset(
                          'assets/images/4.png',
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(singUp);
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Don't Have An Account ? "),
                            TextSpan(
                              text: "Register",
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
