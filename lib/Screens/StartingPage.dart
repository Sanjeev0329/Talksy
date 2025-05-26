import 'package:chatify/Helper/uiHelper.dart';
import 'package:chatify/Screens/Signin screen.dart';
import 'package:chatify/Screens/Signup screen.dart';
import 'package:flutter/material.dart';

class startingPage extends StatefulWidget {
  @override
  State<startingPage> createState() => _startingPageState();
}

class _startingPageState extends State<startingPage> {
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.05),
              Center(
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                "Start with signing up or sign in",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade200,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height * 0.04),
              Image.asset(
                'Assets/images/chatlogo.jpg',
                height: height * 0.3,
                width: width * 0.7,
                fit: BoxFit.contain,
              ),
              SizedBox(height: height * 0.05),
              uiHelper.customButton(() {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => signUpPage()));
              }, "Sign Up", Colors.blue),
              SizedBox(height: 20),
              uiHelper.customButton(() {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => signInPage()));
              }, "Sign In", Colors.green),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
