import 'package:codeclause/pages/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController emailController = TextEditingController();
  forgotpassword(String email) {
    if (email == "") {
      Uihelper.customAlertBox(context, "Enter the reuired fields");
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"), centerTitle: true),
      body: Column(
        children: [
          Uihelper.customTextField(
            emailController,
            "Enter Registered Email",
            Icons.email_rounded,
            false,
          ),
          SizedBox(height: 20),
          Uihelper.customButton(() {
            forgotpassword(emailController.text.toString());
          }, "Reset Password"),
        ],
      ),
    );
  }
}
