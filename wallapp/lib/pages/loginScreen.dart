import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/button.dart';
import 'package:wallapp/components/textfield.dart';
import 'package:wallapp/pages/registerPage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordCOntroller = TextEditingController();

    void signIn() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordCOntroller.text.trim());
      } on FirebaseAuthException catch (e) {
        if (e.code == "invalid-credential") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Are lauda email/password kya tha !')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.code)));
        }
      }
    }

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
                'Mitsuha :)',
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
                      emailController: _passwordCOntroller,
                      pageIcon: const Icon(Icons.password),
                      hintText: 'Password',
                    ),
                    MyButton(
                      text: 'Login',
                      onTap: signIn,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member? '),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RegisterPage();
                            }));
                          },
                          child: const Text(
                            'Register Now',
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
