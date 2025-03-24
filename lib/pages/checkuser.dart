import 'package:codeclause/main.dart';
import 'package:codeclause/pages/login.dart';
import 'package:codeclause/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Checkuser extends StatefulWidget {
  const Checkuser({super.key});

  @override
  State<Checkuser> createState() => _CheckuserState();
}

class _CheckuserState extends State<Checkuser> {
  Widget currentpage = Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
  @override
  void initState() {
    super.initState();
    checkuser();
  }

  checkuser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      if (user != null) {
        currentpage = MyHomePage(title: "Home Page");
      } else {
        currentpage = MyloginPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentpage;
  }
}
