import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login', (route) => false);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        child: FirebaseAuth.instance.currentUser!.emailVerified
            ? const Text('welcome')
            : MaterialButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                },
                child: const Text('please verfied Email'),
              ),
      ),
    );
  }
}
