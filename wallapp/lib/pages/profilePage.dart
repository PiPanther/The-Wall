import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  Future<void> editField(String field) async {
    String newVal = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pink.shade50,
          title: Text(
            'Edit $field',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newVal = value;
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(newVal);
                },
                child: Text('Save')),
          ],
        );
      },
    );

    if (newVal.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newVal});
    }
    // You can use newVal here or return it if needed.
  }

  // final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        backgroundColor: Colors.pink.shade400,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userdata = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  // user email
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(
                      color: Colors.pink.shade400,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                  ),
                  // user details
                  ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          editField('Username');
                        },
                        icon: const Icon(Icons.edit)),
                    title: Text(userdata['Username']),
                    subtitle: Text(
                      'Username',
                    ),
                    // isThreeLine: true,
                    leading: CircleAvatar(
                      child: Text('A'),
                      maxRadius: 25,
                    ),
                  ),
                  ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          editField("Bio");
                        },
                        icon: const Icon(Icons.edit)),
                    title: Text(userdata['Bio']),
                    subtitle:const  Text(
                      'Bio',
                    ),
                    // isThreeLine: true,
                  ),
                  // username

                  // userbio

                  // user posts
                ],
              ),
            );
          } else if (snapshot.hasError) {
            displayMessage(snapshot.error.toString());
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
