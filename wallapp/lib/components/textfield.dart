import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController emailController;
  Icon? pageIcon;
  String hintText;
  MyTextField(
      {super.key,
      required this.emailController,
      this.pageIcon,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          icon: pageIcon,
          // hintText: 'Email',
          label: Text(hintText),

          hintStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.deepPurpleAccent, width: 1),
              borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}
