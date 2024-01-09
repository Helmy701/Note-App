import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
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
              Text("Help",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Get Support",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () async {
                  const number = '+201028721580'; //set the number here
                  await FlutterPhoneDirectCaller.callNumber(number);
                },
                child: const Icon(Icons.phone_iphone,
                    color: Colors.orange, size: 75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
