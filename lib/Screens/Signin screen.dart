import 'package:chatify/Helper/uiHelper.dart';
import 'package:chatify/Screens/Signup screen.dart';
import 'package:chatify/Screens/forgotpassword.dart';
import 'package:chatify/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signInPage extends StatefulWidget {
  @override
  State<signInPage> createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLoading = false;

  signIn(String email, String pass) async {
    setState(() {
      isLoading = true;
    });

    if (email == "" || pass == "") {
      setState(() {
        isLoading = false;
      });
      return uiHelper.customAlertBox(context, "Please enter valid fields");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } on FirebaseAuthException catch (ex) {
        uiHelper.customAlertBox(context, ex.code.toString());
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.cyan.shade600,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.message)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.cyan.shade600,
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    "Login fast your friends at chat",
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  topLeft: Radius.circular(100),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  uiHelper.customTextField(
                      email, "Enter your Email id..", Icons.email_rounded, false),
                  SizedBox(height: height * 0.025),
                  uiHelper.customTextField(
                      pass, "Enter your password..", Icons.lock, true),
                  SizedBox(height: height * 0.05),

                  isLoading
                      ? CircularProgressIndicator()
                      : uiHelper.customButton(() {
                    signIn(email.text.trim(), pass.text.trim());
                  }, "Sign in", Colors.blue),

                  SizedBox(height: height * 0.03),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgotPassword()));
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signUpPage()),
                          );
                        },
                        child: Text(
                          "Sign up here",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: height*0.18,)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
