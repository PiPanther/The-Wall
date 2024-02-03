import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/components/comments.dart';
import 'package:wallapp/components/likeButton.dart';
import 'package:wallapp/helpers/formatDate.dart';

class WallPost extends StatefulWidget {
  String message;
  String user;
  String postId;
  List<String> likes;

  WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    isLiked = widget.likes.contains(currentUser.email);
    super.initState();
  }

  void addComment(String commentText) async {
    await FirebaseFirestore.instance
        .collection('User Comments')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.displayName,
      "CommentTime": Timestamp.now(),
    });
    Navigator.pop(context);
    commentController.clear();
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a new comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "Write a comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => addComment(commentController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void toggleLikes() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postref =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postref.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postref.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.fromLTRB(25, 25, 25, 0),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLikes),
                  const SizedBox(width: 8),
                  Text(widget.likes.length.toString()),
                ],
              ),
              Row(
                children: [
                  Badge(
                    label: const Text('0'),
                    alignment: Alignment.topRight,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey,
                    child: IconButton(
                      onPressed: () {
                        showCommentDialog();
                      },
                      icon: const Icon(Icons.comment),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Badge(
                    label: Text(widget.likes.length.toString()),
                    backgroundColor: Colors.transparent,
                    textColor: Colors.grey,
                    child: LikeButton(isLiked: isLiked, onTap: toggleLikes),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.user,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            widget.message,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                height: 200, // Replace with the desired height or use Expanded
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      text: commentData['CommentText'],
                      user: commentData['CommentedBy'],
                      time: formatDate(commentData['CommentTime']),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
