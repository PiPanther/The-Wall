import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  String text;
  String user;
  String time;

  Comment({required this.text, required this.user, required this.time});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.pink.shade50, borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Text(widget.text),
          Row(
            children: [
              Text(widget.user),
              Text(widget.time),
            ],
          )
        ],
      ),
    );
  }
}
