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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeds'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/CreateFeedPage/');
            },
            child: const Icon(
              Icons.add_box_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
