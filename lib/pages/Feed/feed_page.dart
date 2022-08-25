import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  final BuildContext? context;
  const FeedPage({Key? key, this.context}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Feed Page'),
    );
  }
}
