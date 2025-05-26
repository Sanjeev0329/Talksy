import 'package:chatify/Helper/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatefulWidget{

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  TextEditingController email = TextEditingController();

  resetPassword(String email) async{
    if(email==""){
      uiHelper.customAlertBox(context, "Please enter email to reset password");
    }
    else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      uiHelper.customAlertBox(context, "Reset link sent to your Email id");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade600,
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           uiHelper.customTextField(email, "Enter your Email", Icons.email_rounded, false),
            SizedBox(height: 30,),
            uiHelper.customButton((){
              resetPassword(email.text.toString());

            },"Reset Password", Colors.blue)
          ],
        ),
      ),

    );
  }
}