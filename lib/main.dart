import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_flutter/firebase_options.dart';
import 'package:twitter_flutter/helper/custom_route.dart';
import 'package:twitter_flutter/helper/theme.dart';
import 'package:twitter_flutter/pages/Auth/forget_password_page.dart';
import 'package:twitter_flutter/pages/Auth/select_auth_methods.dart';
import 'package:twitter_flutter/pages/Auth/signin_page.dart';
import 'package:twitter_flutter/pages/Auth/signup_page.dart';
import 'package:twitter_flutter/pages/Feed/create_feed_page.dart';
import 'package:twitter_flutter/pages/Feed/feed_detail_page.dart';
import 'package:twitter_flutter/pages/Feed/feed_reply_page.dart';
import 'package:twitter_flutter/pages/Feed/image_view_page.dart';
import 'package:twitter_flutter/pages/Profile/edit_profile_page.dart';
import 'package:twitter_flutter/pages/Profile/profile_page.dart';
import 'package:twitter_flutter/pages/home_page.dart';
import 'package:twitter_flutter/states/app_state.dart';
import 'package:twitter_flutter/states/auth_state.dart';
import 'package:twitter_flutter/states/chat_state.dart';
import 'package:twitter_flutter/states/feed_state.dart';
import 'package:twitter_flutter/widgets/custom_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppState _appState = AppState();
  final AuthState _authState = AuthState();
  final FeedState _feedState = FeedState();
  final ChatState _chatState = ChatState();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (context) => _appState),
        ChangeNotifierProvider<AuthState>(create: (context) => _authState),
        ChangeNotifierProvider<FeedState>(create: (context) => _feedState),
        ChangeNotifierProvider<ChatState>(create: (context) => _chatState),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: apptheme,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Twitter Flutter'),
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name!.split('/');

          if (pathElements[0] != '' || pathElements.length == 1) {
            return null;
          }

          if (pathElements[1].contains('SignIn')) {
            return CustomRoute<bool>(
              builder: (context) => const SignInPage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('SignUp')) {
            return CustomRoute<bool>(
              builder: (context) => const SignUpPage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('ForgetPasswordPage')) {
            return CustomRoute<bool>(
              builder: (context) => const ForgetPasswordPage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('HomePage')) {
            return CustomRoute<bool>(
              builder: (context) => const HomePage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('CreateFeedPage')) {
            return CustomRoute<bool>(
              builder: (context) => const CreateFeedPage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('Profile')) {
            String profileId = pathElements[2];
            return CustomRoute<bool>(
              builder: (context) => ProfilePage(profileId: profileId),
              settings: settings,
            );
          }

          if (pathElements[1].contains('EditProfile')) {
            return CustomRoute<bool>(
              builder: (context) => const EditProfilePage(),
              settings: settings,
            );
          }

          if (pathElements[1].contains('FeedPostDetail')) {
            String postId = pathElements[2];
            return CustomRoute<bool>(
              builder: (context) => FeedPostDetail(
                postId: postId,
              ),
              settings: settings,
            );
          }

          if (pathElements[1].contains('FeedReplyPage')) {
            String postId = pathElements[2];
            return CustomRoute<bool>(
              builder: (context) => FeedReplyPage(
                postId: postId,
              ),
              settings: settings,
            );
          }

          if (pathElements[1].contains('ImageViewPage')) {
            return CustomRoute<bool>(
              builder: (context) => const ImageViewPage(),
              settings: settings,
            );
          }
          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            final String unknownRoute = settings.name!.split('/')[1];
            return Scaffold(
              appBar: AppBar(
                title: customTileText(unknownRoute),
              ),
              body: Center(child: Text('$unknownRoute Comming soon...')),
            );
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const SelectAuthMethods();
  }
}
