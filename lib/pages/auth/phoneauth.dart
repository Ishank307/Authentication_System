import 'package:codeclause/pages/auth/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Phoneauth extends StatefulWidget {
  const Phoneauth({super.key});

  @override
  State<Phoneauth> createState() => _PhoneauthState();
}

class _PhoneauthState extends State<Phoneauth> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                //prefixText: "+91",
                hintText: "Enter phone no",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              debugPrint(phoneController.text.toString());
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: phoneController.text.toString(),
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException ex) {
                  debugPrint("XXXXXXXXXXXXX   $ex");
                },
                codeSent: (String verificationid, int? resendtoken) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Otpscreen(verficationid: verificationid),
                    ),
                  );
                },
                codeAutoRetrievalTimeout: (String verificationid) {
                  debugPrint("XXXXXXXXXXXXX   $verificationid");
                },
              );
            },
            child: Text("Verify you phone number"),
          ),
        ],
      ),
    );
  }
}
