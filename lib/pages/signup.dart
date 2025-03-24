import 'package:codeclause/main.dart';
import 'package:codeclause/pages/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      Uihelper.customAlertBox(context, "Enter Required Fields"); // Now works!
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Home Page")),
      );
    } on FirebaseAuthException catch (ex) {
      if (!mounted) return;
      Uihelper.customAlertBox(context, ex.code.toString()); // Now works!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SignUp",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Uihelper.customTextField(
            emailController,
            "Email",
            Icons.email,
            false,
          ),
          Uihelper.customTextField(
            passwordController,
            "Password",
            Icons.email,
            true,
          ),
          SizedBox(height: 30, width: double.infinity),
          Uihelper.customButton(() {
            signUp(
              emailController.text.toString(),
              passwordController.text.toString(),
            );
          }, "SignUp"),
        ],
      ),
    );
  }
}
