import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  @override
  void initState() {
    super.initState();
  }

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify"),
        ),
        body: Column(
          children: [
            const Text("We have send a verification email to your account."),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await auth.currentUser?.reload();

                    if (auth.currentUser!.emailVerified == true) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Login();
                      }));
                    }
                  },
                  child: const Text("I have verified my email")),
            ),
          ],
        ));
  }
}
