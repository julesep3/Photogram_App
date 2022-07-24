import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/addnewphotomemo_screen.dart';
import 'package:lesson3/viewscreen/addpubliccomment_screen.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/feed_screen.dart';
import 'package:lesson3/viewscreen/internalerror_screen.dart';
import 'package:lesson3/viewscreen/publicdetailed_screen.dart';
import 'package:lesson3/viewscreen/publicsearch_screen.dart';
import 'package:lesson3/viewscreen/settings_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_detailedview_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/signUp_screen.dart';
import 'package:lesson3/viewscreen/signin_screen.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Lesson3App());
}

class Lesson3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        UserHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at UserHomeScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            var photoMemoCommentList = argument[ARGS.PhotoMemoCommentList];
            return UserHomeScreen(
              user: user,
              photoMemoList: photoMemoList,
              photoMemoCommentList: photoMemoCommentList,
            );
          }
        },
        SharedWithScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at SharedWithScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return SharedWithScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        AddNewPhotoMemoScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at AddNewPhotoMemoScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return AddNewPhotoMemoScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        DetailedViewScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at DetailedViewScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            var photoMemoCommentList = argument[ARGS.PhotoMemoCommentList];
            return DetailedViewScreen(
              user: user,
              photoMemo: photoMemo,
              photoMemoCommentList: photoMemoCommentList,
            );
          }
        },
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SharedWithDetailedViewScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen(
                'args is null at SharedWithDetailedViewScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            return SharedWithDetailedViewScreen(
              user: user,
              photoMemo: photoMemo,
            );
          }
        },
        SettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at SettingsScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            var photoMemoCommentList = argument[ARGS.PhotoMemoCommentList];
            return SettingsScreen(
              user: user,
              photoMemoList: photoMemoList,
              photoMemoCommentList: photoMemoCommentList,
            );
          }
        },
        FeedScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at FeedScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return FeedScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        AddPublicCommentScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen(
                'args is null at AddPublicCommentScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            return AddPublicCommentScreen(
              user: user,
              photoMemo: photoMemo,
            );
          }
        },
        PublicSearchScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at PublicSearchScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return PublicSearchScreen(
              user: user,
              publicPhotoMemoList: photoMemoList,
            );
          }
        },
        PublicDetailedScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at PublicDetailedScreen');
          } else {
            // convert args to User type
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            return PublicDetailedScreen(
              user: user,
              photoMemo: photoMemo,
            );
          }
        },
      },
    );
  }
}
