import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/user_model.dart';
import 'package:twitter_flutter/states/app_state.dart';

class SearchState extends AppState {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel>? _userList;
  List<UserModel>? get userList => _userList;

  List<UserModel>? _userFilterList;
  List<UserModel>? get userFilterList => _userFilterList;

  void getDataFromDatabase() async {
    try {
      final usersSnap = await _firestore.collection('profiles').get();
      final usersData = usersSnap.docs.map((doc) => doc.data()).toList();

      _userList = [];
      for (var data in usersData) {
        _userList!.add(UserModel.fromJson(data));
      }
      notifyListeners();
    } catch (e) {
      Utility.cprint(e.toString());
    }
  }

  void filterByUsername(String? text) {
    if (_userList == null || _userList!.isEmpty) {
      Utility.cprint('Empty userList');
      return;
    }

    if (text == null || text.isEmpty) {
      _userFilterList = List.from(_userList!);
    } else {
      _userFilterList = _userList!
          .where((x) =>
              x.username != null &&
              x.username!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
