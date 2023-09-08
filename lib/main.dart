import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/chat.dart';
import 'package:flutter_app/login.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const Chat()
          : const Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase"),
      ),
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
                      final user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailCtrl.text, password: passCtrl.text);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Registered Successfully"),
                          backgroundColor: Colors.green,
                        ));
                      }
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.message!),
                        backgroundColor: Colors.red,
                      ));
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Something went wrong"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
