import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Hello"),
            ElevatedButton(
                onPressed: () async {
                  await for (var snapshot in FirebaseFirestore.instance
                      .collection('messages')
                      .snapshots()) {
                    for (var message in snapshot.docs) {
                      print(">>>>>>");
                      print(message.data());
                    }
                  }
                },
                child: Text("Get Messages")),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('messages').add({
                    "sender": "julio@gmail.com",
                    "message": "my selfie",
                    "photo": "../image/s.jpg"
                  });
                },
                child: Text("Send Message"))
          ],
        ),
      ),
    );
  }
}
