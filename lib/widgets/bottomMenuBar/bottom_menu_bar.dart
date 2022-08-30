// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/widgets/bottomMenuBar/tab_item.dart';

import '../../states/app_state.dart';

class BottomMenuBar extends StatefulWidget {
  final PageController? pageController;
  const BottomMenuBar({Key? key, this.pageController}) : super(key: key);

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  late final PageController? _pageController;

  @override
  void initState() {
    _pageController = widget.pageController;
    super.initState();
  }

  Widget _iconRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -.1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _icon(Icons.home, 0),
          _icon(Icons.search, 1),
          _icon(Icons.mail_outline, 2),
        ],
      ),
    );
  }

  Widget _icon(IconData iconData, int index,
      {bool isCustomIcon = false, int? icon}) {
    var state = Provider.of<AppState>(context);
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: const Duration(milliseconds: animDuration),
          curve: Curves.easeIn,
          alignment: const Alignment(
            0,
            iconOn,
          ),
          child: AnimatedOpacity(
            opacity: alphaOn,
            duration: const Duration(milliseconds: animDuration),
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              icon: Icon(
                iconData,
                color: index == state.pageIndex
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.caption!.color,
              ),
              onPressed: () {
                setState(() {
                  state.setPageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
