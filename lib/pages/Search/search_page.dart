import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/search_state.dart';
import 'package:twitter_flutter/widgets/custom_appbar.dart';
import 'dart:async';

import 'package:twitter_flutter/widgets/custom_widget.dart';

import '../../helper/theme.dart';

class SearchPage extends StatefulWidget {
  final BuildContext? context;
  const SearchPage({Key? key, this.context}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;

  @override
  void initState() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void onSearch() {
    Utility.cprint('onSearch');
  }

  Widget _userTitle(UserModel userModel) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/Profiles/${userModel.userId}');
      },
      leading: customImage(
        context,
        userModel.photoUrl ?? dummyProfilePic,
        height: 40,
      ),
      title: Row(
        children: [
          Text(
            userModel.displayName ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          userModel.isVerified ?? false
              ? customIcon(context,
                  icon: const IconData(AppIcon.blueTick),
                  isTwitterIcon: true,
                  iconColor: AppColor.primary,
                  size: 13,
                  paddingIcon: 3)
              : const SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var searchState = Provider.of<SearchState>(context, listen: true);
    var userlist = searchState.userList;
    return Scaffold(
      appBar: CustomAppBar(
        textController: null,
        icon: Icons.settings,
        onActionPressed: onSearch,
        onSearchChanged: (text) {
          if (_debounce?.isActive ?? false) {
            _debounce?.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 500), () {
            searchState.filterByUsername(text);
          });
        },
      ),
      body: userlist == null
          ? Container()
          : ListView.separated(
              itemBuilder: (context, index) => _userTitle(userlist[index]),
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: userlist.length,
            ),
    );
  }
}
