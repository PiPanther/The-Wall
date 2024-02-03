import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/drawer.dart';
import 'package:wallapp/components/textfield.dart';
import 'package:wallapp/components/wallPosts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  void postMessage() async {
    try {
      // only post if there is something in the textfield
      if (postController.text.isNotEmpty) {
        // store the message in the database
        await FirebaseFirestore.instance.collection("User Posts").add({
          'UserEmail': currentUser!.email,
          'Message': postController.text,
          'Timestamp': Timestamp.now(),
          'Likes': [],
        });
        // clear the text field after posting
        postController.clear();
      }
    } catch (e) {
      displayMessage(e.toString());
      // Handle the error as needed (e.g., show a message to the user)
    }
  }

  TextEditingController postController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Mitsuha',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink.shade400),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .orderBy("Timestamp", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data!.docs[index];
                              return WallPost(
                                message: post['Message'],
                                user: post['UserEmail'],
                                postId: post.id,
                                likes: List<String>.from(post['Likes'] ?? []),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: Text('No posts found'),
                      );
                    }),
              ),
              // padding: const EdgeInsets.all(8),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        emailController: postController,
                        // pageIcon: Icon(Icons.arrow_circle_up_outlined,),
                        hintText: 'Post something ...'),
                  ),
                  IconButton.outlined(
                      onPressed: () {
                        postMessage();
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
