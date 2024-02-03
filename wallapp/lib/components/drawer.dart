// import 'dart:js_interop_unsafe';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/myListTile.dart';
import 'package:wallapp/pages/profilePage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.pink.shade500,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
              child: Icon(
            Icons.person,
            color: Colors.black,
            size: 64,
          )),
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.home,
            text: 'P R O F I L E',
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfilePage();
            })),
          ),
          MyListTile(
            icon: Icons.home,
            text: 'L O G O U T',
            onTap: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }
}
