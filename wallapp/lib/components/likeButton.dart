import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  bool isLiked;
  void Function()? onTap;
  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: isLiked
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border_outlined),
      color: isLiked ? Colors.red : Colors.grey.shade400,
    );
  }
}
