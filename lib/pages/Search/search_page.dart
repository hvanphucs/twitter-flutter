import 'package:flutter/cupertino.dart';

class SearchPage extends StatefulWidget {
  final BuildContext? context;
  const SearchPage({Key? key, this.context}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search page'),
    );
  }
}
