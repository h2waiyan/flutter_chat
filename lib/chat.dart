import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/login.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController msgCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    print(FirebaseAuth.instance.currentUser!.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Login();
                }));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .snapshots(),
                builder: ((context, snapshot) {
                  List<MessageBubble> messagesWidget = [];

                  if (snapshot.hasData) {
                    for (var message in snapshot.data!.docs) {
                      messagesWidget.add(MessageBubble(
                        text: message['message'],
                        sender: message['sender'],
                        isMe: FirebaseAuth.instance.currentUser!.email ==
                                message['sender']
                            ? true
                            : false,
                      ));
                    }
                  }

                  return Expanded(child: ListView(children: messagesWidget));
                })),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: TextField(
                    controller: msgCtrl,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "Drop a message"),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('messages')
                          .add({
                        "sender": "julio@gmail.com",
                        "message": msgCtrl.text,
                        "photo": "../image/s.jpg"
                      });
                    },
                    child: const Text("Send Message")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(sender),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 102, 143, 212),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Text(text),
            ),
          ),
        ),
      ],
    );
  }
}
