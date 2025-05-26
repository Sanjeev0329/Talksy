import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatify/Helper/secrets.dart'; //  API key file

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? pickedImage;
  String? profileImageUrl; // To store the image URL

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          nameController.text = data['Name'] ?? '';
          aboutController.text = data['About'] ?? '';
          phoneController.text = data['Phone'] ?? '';
          addressController.text = data['Address'] ?? '';
          profileImageUrl = data['Image']; // Store the image URL here
        });
      }
    }
  }

  Future<String?> uploadImageToImgBB(File imageFile) async {
    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey");
    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());
      final response = await http.post(url, body: {'image': base64Image});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        log("Upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Upload error: $e");
      return null;
    }
  }

  Future<void> saveProfile() async {
    if (pickedImage == null ||
        nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        aboutController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Please fill all fields and pick an image."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final imageUrl = await uploadImageToImgBB(pickedImage!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image upload failed.")));
      return;
    }

    await FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
      "Image": imageUrl,
      "Name": nameController.text,
      "Phone": phoneController.text,
      "Address": addressController.text,
      "About": aboutController.text,
      "Email": user.email,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully.")));
  }

  void _showEditBottomSheet(String field, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Enter your $field", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))],
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Enter your $field",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                  SizedBox(width: 50),
                  TextButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text("Save")),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile", style: TextStyle(color: Colors.black, fontSize: 28))),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, size: 35)),
                        Text("Profile Photo", style: TextStyle(fontSize: 20)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline, size: 35)),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.camera_alt_outlined, size: 35, color: Colors.green)),
                            Text("Camera")
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.photo_size_select_actual_outlined,
                                    size: 35, color: Colors.green)),
                            Text("Gallery")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              );
            },
            child: pickedImage != null
                ? CircleAvatar(radius: 100, backgroundImage: FileImage(pickedImage!))
                : profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? CircleAvatar(radius: 100, backgroundImage: NetworkImage(profileImageUrl!))
                : CircleAvatar(radius: 100, child: Icon(Icons.person, size: 100)),
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () => _showEditBottomSheet("Name", nameController),
            child: ListTile(
              leading: Icon(Icons.person_outline_outlined, size: 35),
              title: Text("Name", style: TextStyle(fontSize: 20)),
              subtitle: Text(nameController.text),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _showEditBottomSheet("About", aboutController),
            child: ListTile(
              leading: Icon(Icons.info_outline, size: 35),
              title: Text("About", style: TextStyle(fontSize: 20)),
              subtitle: Text(aboutController.text),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _showEditBottomSheet("Phone", phoneController),
            child: ListTile(
              leading: Icon(Icons.phone_outlined, size: 35),
              title: Text("Phone", style: TextStyle(fontSize: 20)),
              subtitle: Text(phoneController.text),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _showEditBottomSheet("Address", addressController),
            child: ListTile(
              leading: Icon(Icons.location_on_outlined, size: 35),
              title: Text("Address", style: TextStyle(fontSize: 20)),
              subtitle: Text(addressController.text),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
              onPressed: () => saveProfile(),
              child: Text("Save Profile", style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }

  pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        setState(() {
          pickedImage = File(picked.path);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
