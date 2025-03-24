import 'dart:developer';

import 'package:codeclause/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Otpscreen extends StatefulWidget {
  String verficationid;
  Otpscreen({super.key, required this.verficationid});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  TextEditingController otpcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otp Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 370,
              child: TextField(
                controller: otpcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter the otp",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verficationid,
                  smsCode: otpcontroller.text.toString(),
                );
                FirebaseAuth.instance.signInWithCredential(credential);

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: "HOME PAGE"),
                    ),
                  );
                }
              } catch (ex) {
                log(ex.toString());
              }
            },
            child: Text("OTP"),
          ),
        ],
      ),
    );
  }
}
