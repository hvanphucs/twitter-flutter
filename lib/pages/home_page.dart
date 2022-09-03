import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/pages/Message/message_users_dart.dart';
import 'package:twitter_flutter/pages/Search/search_page.dart';
import 'package:twitter_flutter/pages/message/message_page.dart';

import '../states/app_state.dart';
import '../widgets/bottomMenuBar/bottom_menu_bar.dart';
import 'Common/side_bar.dart';
import 'Feed/feed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  @override
  void initState() {
    //var state = Provider.of<AppState>(context, listen: false);
    //state.setPageIndex = 0;
    super.initState();
  }

  Widget _getPage(int index, {BuildContext? context}) {
    switch (index) {
      case 0:
        return FeedPage(context: context);
      case 1:
        return SearchPage(context: context);
      case 2:
        return MessageUsersList(context: context);
      default:
        return FeedPage(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      drawer: const SilderBar(),
      bottomNavigationBar: const BottomMenuBar(),
      body: Container(
        child: _getPage(state.pageIndex),
      ),
    );
  }
}
