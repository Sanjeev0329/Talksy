import 'package:chatify/Helper/uiHelper.dart';
import 'package:chatify/Screens/Signin screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUpPage extends StatefulWidget {
  @override
  State<signUpPage> createState() => _logInPageState();
}

class _logInPageState extends State<signUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController fullName = TextEditingController();
  bool isChecked = false;

  signUp(String email, String pass) async {
    if (email == "" && pass == "") {
      uiHelper.customAlertBox(context, "Enter the required fields");
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user?.uid)
              .set({
            'FullName': fullName.text,
            'UserName': userName.text,
            'PhoneNumber': phoneNumber.text,
            'Email': email,
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => signInPage()));
        } else {
          uiHelper.customAlertBox(
              context, "Failed to create user. Please try again.");
        }
      } on FirebaseAuthException catch (ex) {
        return uiHelper.customAlertBox(context, ex.code.toString());
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
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              color: Colors.cyan.shade600,
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),
                  Center(
                    child: Text("Register",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 40,
                            fontWeight: FontWeight.w900)),
                  ),
                  SizedBox(height: height * 0.049),
                  Text(
                    "You and Your Buddy's always Connected",
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100))),
              child: Column(
                children: [
                  uiHelper.customTextField(
                      fullName, "Full Name", Icons.person_2_outlined, false),
                  SizedBox(height: height * 0.02),
                  uiHelper.customTextField(userName, "User Name",
                      Icons.supervised_user_circle_rounded, false),
                  SizedBox(height: height * 0.02),
                  uiHelper.customTextField(
                      email, "Email id", Icons.email_rounded, false),
                  SizedBox(height: height * 0.02),
                  uiHelper.customTextField(
                      phoneNumber, "Phone Number", Icons.phone, false),
                  SizedBox(height: height * 0.02),
                  uiHelper.customTextField(
                      pass, "Password", Icons.lock, true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          }),
                      Flexible(
                        child: Text(
                          "I agree all the Terms and Conditions",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  uiHelper.customButton(() {
                    signUp(email.text.toString(), pass.text.toString());
                  }, "Create Account", Colors.blue),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signInPage()));
                          },
                          child: Text("LogIn",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w800)))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
