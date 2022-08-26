import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/helper/constants.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/helper/utility.dart';
import 'package:twitter_flutter/models/feed_model.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/widgets/custom_appbar.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

import '../../states/feed_state.dart';
import '../../widgets/newWidget/custom_urltext.dart';

class FeedPage extends StatefulWidget {
  final BuildContext? context;
  const FeedPage({Key? key, this.context}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    var feedState = Provider.of<FeedState>(context, listen: false);
    //feedState.getDataFromDatabase();
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage');
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _body() {
    var feedState = Provider.of<FeedState>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feeds').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return loader();
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return _postCard(snapshot.data!.docs[index]);
            },
          );
        }
      },
    );
  }

  Widget _postCard(QueryDocumentSnapshot documentSnapshot) {
    var state = Provider.of<AuthState>(context, listen: false);
    Map<String, dynamic> feedData = documentSnapshot.data() as dynamic;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: customListTile(
            context,
            onTap: () {},
            leading: customInkWell(
              context: context,
              function2: () {
                Navigator.of(context).pushNamed('');
              },
              child: customImage(
                  context, feedData['profilePic'] ?? dummyProfilePic),
            ),
            title: Row(
              children: <Widget>[
                customText(feedData['name'], style: titleStyle),
                const SizedBox(
                  width: 10,
                ),
                customText('- ${Utility.getChatTime(feedData['createdAt'])}',
                    style: subtitleStyle)
              ],
            ),
            subtitle: UrlText(
              text: feedData['description'],
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w400),
              urlStyle: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: _floatingActionButton(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: _body(),
        ),
      ),
    );
  }
}
