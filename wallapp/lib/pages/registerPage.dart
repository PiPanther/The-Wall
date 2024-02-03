import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallapp/components/button.dart';
import 'package:wallapp/components/textfield.dart';
import 'package:wallapp/pages/homepage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    if (_passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage('Passwords don\'t match');
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text,
              password: confirmPasswordController.text);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': _emailController.text.split('@')[0],
        'bio': 'empty bio',
      });
      Navigator.pop(context);
      displayMessage("Signed up successfully");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Image.asset(
                "lib/assets/logo.png",
                height: size.width * 0.5,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              const Text(
                'Mitsuha',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.amber,
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    MyTextField(
                        hintText: 'Email',
                        emailController: _emailController,
                        pageIcon: const Icon(Icons.email_outlined)),
                    MyTextField(
                      emailController: _passwordController,
                      pageIcon: const Icon(Icons.password),
                      hintText: 'Password',
                    ),
                    MyTextField(
                      emailController: confirmPasswordController,
                      pageIcon: const Icon(Icons.password),
                      hintText: 'R-enter Password',
                    ),
                    MyButton(
                      text: 'Register',
                      onTap: signUp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already a member? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.pinkAccent),
                          ),
                        ),
                        // const Spacer(),
                      ],
                    )
                    // Spacer()
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
