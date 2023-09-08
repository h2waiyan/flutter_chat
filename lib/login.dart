import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chat.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Future<UserCredential> _handleSignIn() async {
  //   try {
  //     // await _googleSignIn.signIn();
  //     GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //     GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount!.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication?.accessToken,
  //       idToken: googleSignInAuthentication?.idToken,
  //     );

  //     var user = await FirebaseAuth.instance.signInWithCredential(credential);
  //     return user;
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Email",
                  icon: Icon(Icons.mail)),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Password",
                  icon: Icon(Icons.password)),
            ),
            MaterialButton(
                color: const Color.fromARGB(255, 217, 100, 238),
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                onPressed: () async {
                  try {
                    var response = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailCtrl.text, password: passCtrl.text);

                    print(response);
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.message!),
                      backgroundColor: Colors.red,
                    ));
                  } catch (err) {
                    print(err);
                  }
                },
                child: const Text("Login")),
            ElevatedButton(
                onPressed: () async {
                  await signInWithGoogle();

                  if (context.mounted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Chat();
                    }));
                  }
                  //await FirebaseAuth.instance.signInWithCredential(credential)
                },
                child: const Text("Sign in with Google"))
          ],
        ),
      ),
    ));
  }
}
