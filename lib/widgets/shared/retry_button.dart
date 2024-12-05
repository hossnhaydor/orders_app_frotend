import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final String message;
  final VoidCallback retry;
  const RetryButton({super.key, required this.message, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          IconButton(
            onPressed: retry,
            icon: const Icon(Icons.refresh, size: 24),
          ),
        ],
      ),
    );
  }
}
