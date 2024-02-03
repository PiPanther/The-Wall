import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final String text;

  const MyListTile(
      {super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.pink.shade400,
      ),
      title: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
