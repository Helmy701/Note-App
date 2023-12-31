import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:waelfirebase/Screens/Authentication/signUp.dart';
import 'package:waelfirebase/Screens/categories/add_category.dart';
import 'package:waelfirebase/Screens/categories/home_page.dart';

import 'package:waelfirebase/constants/constants.dart';
import 'Screens/Authentication/login.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  // await Firebase.initializeApp();

  // print("Handling a background message: ${message.messageId}");
  print('====================background message');
  print(message.notification!.title);
  print('====================background message');
}

void main() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('====================================');
        print(message.notification!.title);
        print(message.notification!.body);
        print('====================================');
      }
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('==========================User is currently signed out!');
      } else {
        print('==========================User is signed in!');
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
          // backgroundColor: Colors.grey[50],
          iconTheme: const IconThemeData(color: Colors.orange),
          titleTextStyle: const TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          color: Colors.grey[50],
        ),
        useMaterial3: true,
      ),
      routes: {
        singUp: (context) => const SignUp(),
        login: (context) => const Login(),
        homePage: (context) => const HomePage(),
        addCategory: (context) => const AddCategory(),
      },
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const HomePage()
          : const Login(),
    );
  }
}
