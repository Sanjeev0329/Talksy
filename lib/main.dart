import 'package:chatify/Helper/uiHelper.dart';
import 'package:chatify/Screens/Profile_page.dart';
import 'package:chatify/Screens/Signin screen.dart';
import 'package:chatify/Helper/userChecker.dart';
import 'package:chatify/Screens/StartingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatify/Screens/SelectUserScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: checkUser(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController search = TextEditingController();
  String searchQuery = "";

  void initState() {
    super.initState();
    search.addListener(() {
      setState(() {
        searchQuery = search.text.toLowerCase();
      });
    });
  }

  logOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => startingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Talksy",
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.qr_code_scanner_outlined,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () {
            },
            icon: Icon(
                Icons.camera_alt_outlined,
                size: 35
            ),
          ),
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(200, 79, 0, 0),
                items: [
                  PopupMenuItem(
                    enabled: false,
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Profile()),
                              );
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Icon(Icons.person_outline_outlined,size: 30,),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Profile Details",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,color: Colors.grey.shade900),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.manage_accounts,
                                      color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Manage Profile',
                                      style: TextStyle(
                                          color: Colors.grey.shade900)),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Settings',
                                      style: TextStyle(
                                          color: Colors.grey.shade900)),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => signInPage()),
                                      );
                                    },
                                    icon: Icon(Icons.logout_outlined,
                                        color: Colors.red),
                                  ),
                                  SizedBox(width: 8),
                                  TextButton(
                                    onPressed: logOut,
                                    child: Text("Logout"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            icon: Icon(Icons.account_circle, color: Colors.grey, size: 46),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SelectUserScreen()),
            );
          },
          child: Icon(Icons.add_comment_rounded, size: 35),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search_outlined, size: 35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').snapshots(),
              builder: (context, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No chat history yet"));
                }

                final allChats = chatSnapshot.data!.docs;
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                // Filter chats involving current user
                final userChats = allChats.where((chat) {
                  final chatId = chat.id;
                  return chatId.contains(currentUserId) && chatId.contains('_');
                }).toList();

                if (userChats.isEmpty) {
                  return Center(child: Text("No previous chats found"));
                }

                return ListView.builder(
                  itemCount: userChats.length,
                  itemBuilder: (context, index) {
                    final chatDoc = userChats[index];
                    final chatId = chatDoc.id;
                    final ids = chatId.split('_');

                    if (ids.length != 2) return SizedBox.shrink();

                    final otherUserId = ids.firstWhere((id) => id != currentUserId);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('Users').doc(otherUserId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                          return ListTile(
                            title: Text("User not found"),
                            subtitle: Text("ID: $otherUserId"),
                          );
                        }

                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        if (searchQuery.isNotEmpty &&
                            !userData['Name'].toString().toLowerCase().contains(searchQuery)) {
                          return SizedBox.shrink();
                        }

                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chatId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, msgSnapshot) {
                            String lastMessage = "No messages yet";
                            String formattedTime = '';

                            if (msgSnapshot.hasData && msgSnapshot.data!.docs.isNotEmpty) {
                              final doc = msgSnapshot.data!.docs.first;
                              lastMessage = doc['text'] ?? lastMessage;

                              final timestamp = doc['timestamp'];
                              if (timestamp != null && timestamp is Timestamp) {
                                formattedTime = TimeOfDay.fromDateTime(timestamp.toDate()).format(context);
                              }
                            }

                            return uiHelper.chatUi(
                              context: context,
                              receiverName: userData['Name'] ?? 'Unknown',
                              receiverImage: userData['Image'] ?? '',
                              receiverId: userData['uid'] ?? otherUserId,
                              lastMessage: lastMessage,
                              time: formattedTime,
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
