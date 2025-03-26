import 'package:codeclause/main.dart';
import 'package:codeclause/pages/auth/phoneauth.dart';
import 'package:codeclause/pages/forgotpassword.dart';
import 'package:codeclause/pages/signup.dart';
import 'package:codeclause/pages/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class MyloginPage extends StatefulWidget {
  const MyloginPage({super.key});

  @override
  State<MyloginPage> createState() => _MyloginPageState();
}

class _MyloginPageState extends State<MyloginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signInWithInGoogle() async {
    // SIGN IN WITH GOOGLE
    try {
      final GoogleSignInAccount? googleuser =
          await GoogleSignIn().signIn(); //begin interactive sign in process

      if (googleuser == null) {
        return;
      }

      //final Google sign in authentication
      final GoogleSignInAuthentication gAuth = await googleuser!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      //sign in with firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Home Page")),
      );
    } catch (e) {
      debugPrint("Error during Sign In");
      Uihelper.customAlertBox(context, "Google Sign in failed");
    }
  }

  //github sign in

  Future<void> signInWithGitHub(BuildContext context) async {
    try {
      //debugPrint("Env variables: ${dotenv.env}"); // Debug print
      //debugPrint("C");
      //debugPrint(dotenv.env["REDIRECT_URL"] ?? "");
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: dotenv.env["CLIENT_ID"] ?? "",
        clientSecret: dotenv.env["CLIENT_SECRET"] ?? "",
        redirectUrl: dotenv.env["REDIRECT_URL"] ?? "",
      );

      final result = await gitHubSignIn.signIn(context);

      switch (result.status) {
        case GitHubSignInResultStatus.ok:
          //debugPrint("GitHub Token: ${result.token}");
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(title: "Home"),
            ),
          );

          break;
        case GitHubSignInResultStatus.cancelled:
        case GitHubSignInResultStatus.failed:
          debugPrint("GitHub Sign-In Failed: ${result.errorMessage}");
          // ignore: use_build_context_synchronously
          Uihelper.customAlertBox(context, "GitHub Sign in failed");
          break;
      }
    } catch (e) {
      debugPrint("GitHub Sign-In Exception: $e");
      // ignore: use_build_context_synchronously
      Uihelper.customAlertBox(
        // ignore: use_build_context_synchronously
        context,
        "An error occurred during GitHub sign-in",
      );
    }
  }

  // sign in with facebook
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return Uihelper.customAlertBox(context, "Enter Required Fields");
    } else {
      UserCredential userCredential;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Home Page"),
          ),
        );
      } on FirebaseAuthException catch (ex) {
        if (!mounted) return;
        Uihelper.customAlertBox(context, ex.code.toString()); // Now works!
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login Page", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 56, 11, 63),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Uihelper.customTextField(
                emailController,
                "Email",
                Icons.mail,
                false,
              ),
              Uihelper.customTextField(
                passwordController,
                "Password",
                Icons.password,
                true,
              ),
              Uihelper.customButton(() {
                login(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                );
              }, "Login"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text("SignUp", style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgotpassword()),
                  );
                },
                child: Text("Forgot Password"),
              ),

              //SizedBox(height: 17),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SignInButton(
                    Buttons.google,
                    text: "Sign In With Google",
                    onPressed: () async {
                      await signInWithInGoogle();
                    },
                  ),
                  SignInButton(
                    Buttons.gitHub,
                    text: "Sign in With Github",
                    onPressed: () async {
                      signInWithGitHub(context);
                    },
                  ),
                  SignInButton(
                    Buttons.facebook,
                    text: "Sign in with Facebook",
                    onPressed: () async {
                      try {
                        final UserCredential userCredential =
                            await signInWithFacebook();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MyHomePage(title: "Home Page"),
                            ),
                          );
                        }
                      } catch (ex) {
                        debugPrint("Facebook Sign-In Exception: $ex");
                        if (context.mounted) return;
                        Uihelper.customAlertBox(context, "Failed");
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Phoneauth()),
                      );
                    },
                    child: Material(
                      elevation: 3,
                      child: Container(
                        height: 35,
                        width: 220,
                        color: const Color.fromARGB(255, 174, 172, 172),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone),

                              Text(
                                "         OTP Login",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
