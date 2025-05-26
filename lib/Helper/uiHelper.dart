
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatify/Screens/ChatScreen.dart';

class uiHelper{
  static customTextField(TextEditingController controller, String text, IconData iconData , bool toHide, ){
    return SizedBox(
      width: 380,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          obscureText: toHide,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            filled: true,
            label: Text(text),
            hintText: text,
              prefixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            )
          ),
        ),
      ),
    );

  }

  static customButton(VoidCallback voidCallback, String text, Color color){
    return SizedBox(
      height: 55,
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor:color,
            elevation: 16,
            shadowColor: Colors.blueAccent,
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))  ),

          onPressed: (){
          voidCallback();
          }, child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
          ))),
    );

  }
  static customAlertBox(BuildContext context,String text){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(text,style: TextStyle(color: Colors.white,fontSize: 19)),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok',style: TextStyle(color: Colors.green,fontSize: 22),))
        ],
      );
    });
  }
  static Widget chatUi({
    required BuildContext context,
    required String receiverName,
    required String receiverImage,
    required String receiverId,
    required String lastMessage,
    required String time,

  }) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                receiverName: receiverName,
                receiverImage: receiverImage,
                receiverId: receiverId,

              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(receiverImage),
              child: receiverImage.isEmpty ? Icon(Icons.person, size: 40) : null,
            ),
            title: Text(receiverName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle:  Text(lastMessage, maxLines: 1),
            trailing:  Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            isThreeLine: false,
          ),
        ),
      ),
    );
  }
}
