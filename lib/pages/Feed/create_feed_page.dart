import 'package:flutter/material.dart';

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({Key? key}) : super(key: key);

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Create Feed page')),
    );
  }
}
