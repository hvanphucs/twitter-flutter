import 'package:flutter/cupertino.dart';

class MessagePage extends StatefulWidget {
  final BuildContext? context;
  const MessagePage({Key? key, this.context}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Message page'),
    );
  }
}
