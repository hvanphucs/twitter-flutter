import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

import '../states/auth_state.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool isBacButton;
  bool isCrossButton;
  Widget? title;
  TextEditingController? textController;
  final String? submitButtonText;
  final Function? onActionPressed;
  final ValueChanged<String>? onSearchChanged;
  bool isSubmitDisable;
  IconData? icon;
  bool isBottomLine;

  Size appBarHeight = const Size.fromHeight(60.0);

  CustomAppBar({
    Key? key,
    this.isBacButton = false,
    this.isCrossButton = false,
    this.title,
    this.textController,
    this.submitButtonText,
    this.onActionPressed,
    this.onSearchChanged,
    this.isSubmitDisable = true,
    this.icon,
    this.isBottomLine = true,
  }) : super(key: key);

  @override
  Size get preferredSize => appBarHeight;

  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        function2: () {},
        child: customImage(
            context, authState.userModel?.photoUrl ?? dummyProfilePic,
            height: 30),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        onChanged: onSearchChanged,
        controller: textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 10, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: 'Search...',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          focusColor: AppColor.white,
          filled: true,
          fillColor: AppColor.lightGrey,

          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //   borderSide: BorderSide(color: Colors.blue),
          // ),
        ),
      ),
    );
  }

  List<Widget> _getActionButton(BuildContext context) {
    return [
      submitButtonText != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: customInkWell(
                context: context,
                radius: BorderRadius.circular(40),
                function2: () {
                  if (onActionPressed != null) {
                    onActionPressed!();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: isSubmitDisable
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withAlpha(150),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    submitButtonText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ))
          : icon == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (onActionPressed != null) {
                      onActionPressed!();
                    }
                  },
                  icon: Icon(icon),
                ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.blue),
      backgroundColor: Colors.white,
      leading: isBacButton
          ? const BackButton()
          : isCrossButton
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                )
              : _getUserAvatar(context),
      title: title ?? _searchField(),
      actions: _getActionButton(context),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: isBottomLine
              ? Colors.grey.shade200
              : Theme.of(context).backgroundColor,
          height: 1.0,
        ),
      ),
    );
  }
}
