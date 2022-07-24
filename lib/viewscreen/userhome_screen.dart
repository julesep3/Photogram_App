import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/addnewphotomemo_screen.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/feed_screen.dart';
import 'package:lesson3/viewscreen/publicsearch_screen.dart';
import 'package:lesson3/viewscreen/settings_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  final User user;
  final List<PhotoMemo> photoMemoList;
  final List<PhotoMemoComment> photoMemoCommentList;
  late final String displayName;
  late final String email;
  late final String profilePicture;

  // constructor takes named params rather than positional
  UserHomeScreen({
    required this.user,
    required this.photoMemoList,
    required this.photoMemoCommentList,
  }) {
    // ?? <-- null aware operator
    // if null, assigns 'N/A', else assigns user.displayName
    displayName = user.displayName ?? 'N/A';
    email = user.email ?? 'no email';
    profilePicture = user.photoURL ?? '';
  }

  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          Future.value(false), // disable Android System back button
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            '${widget.displayName}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            con.delIndexes.isEmpty
                ? Container()
                : Row(
                    children: [
                      IconButton(
                        onPressed: con.delete,
                        icon: Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: con.cancelDelete,
                        icon: Icon(Icons.cancel),
                      ),
                    ],
                  )
          ],
        ),
        // drawer
        drawer: Drawer(
          child: Container(
            color: Colors.black87,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.profilePicture),
                      backgroundColor: Colors.purpleAccent,
                      maxRadius: 33,
                    ),
                  ),
                  accountName: Text(widget.displayName),
                  accountEmail: Text(widget.email),
                ),
                ListTile(
                  leading: Icon(Icons.photo_library_outlined),
                  title: Text('Settings'),
                  onTap: con.navToSettings,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                  onTap: con.signOut,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // User Info Row (profile pic, posts, followers, following)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage:
                                  NetworkImage(widget.profilePicture),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '${widget.photoMemoList.length}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Posts',
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '155',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  'Followers',
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                              children: [
                                Text(
                                  '2,255',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  'Following',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.31,
                        padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.displayName),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Sort Dropdown Button
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 58,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: null,
                        onChanged: (int? value) {
                          value == 0
                              ? con.getListMostRecentlyUpdated()
                              : value == 1
                                  ? con.getListNewestFirst()
                                  : value == 2
                                      ? con.getListOldestFirst()
                                      : value == 3
                                          ? con.getListAlphabetical()
                                          : value == 4
                                              ? con.getListReverseAlphabetical()
                                              : print('ok');
                        },
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Colors.black87,
                        isExpanded: true,
                        hint: Center(child: Text('Sort by')),
                        items: [
                          DropdownMenuItem(
                            child: Center(
                              child: Text('Most Recently Updated First'),
                            ),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Center(
                              child: Text('Newest Photogram First'),
                            ),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Center(
                              child: Text('Oldest Photogram First'),
                            ),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Center(
                              child: Text('Alphabetical Order (A-Z by Title)'),
                            ),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Center(
                              child: Text(
                                  'Reverse Alphabetical Order (Z-A by Title)'),
                            ),
                            value: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Gridview photomemo collection
                con.photoMemoList.isEmpty
                    ? Text(
                        'No PhotoMemo found!',
                        style: Theme.of(context).textTheme.headline6,
                      )
                    : Container(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.photoMemoList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.network(
                                    con.photoMemoList[index].photoURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () => con.onTap(index),
                                  onLongPress: () => con.onLongPress(index),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                widget.photoMemoList[index]
                                            .newSharedwithComment ||
                                        widget.photoMemoList[index]
                                            .newPublicComment
                                    ? Positioned(
                                        right: 5,
                                        top: 5,
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      )
                                    : SizedBox(),
                                con.delIndexes.contains(index)
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.red.withOpacity(0.25),
                                        child: OutlinedButton(
                                          onPressed: () => con.onTap(index),
                                          onLongPress: () =>
                                              con.onLongPress(index),
                                          child: Container(),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          iconSize: 30,
          currentIndex: 0,
          onTap: (int index) {
            if (index == 0) con.feedButton();
            if (index == 1) con.searchButton();
            if (index == 2) con.addButton();
            if (index == 3) con.sharedWith();
            if (index == 4) con.homeButton();
          },
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                child: Icon(
                  Icons.home_outlined,
                ),
              ),
              label: '',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera_front_outlined,
              ),
              label: '',
            ),
            // User Profile Pic Avatar
            BottomNavigationBarItem(
              icon: con.newComments()
                  ? Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 18,
                          child: CircleAvatar(
                            maxRadius: 16,
                            backgroundColor: Colors.purpleAccent,
                            backgroundImage:
                                NetworkImage(widget.profilePicture),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 18,
                      child: CircleAvatar(
                        maxRadius: 16,
                        backgroundColor: Colors.purpleAccent,
                        backgroundImage: NetworkImage(widget.profilePicture),
                      ),
                    ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _UserHomeState state;
  late List<PhotoMemo> photoMemoList;
  late List<PhotoMemoComment> photoMemoCommentList;
  String? searchKeyString;
  List<int> delIndexes = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
    photoMemoCommentList = state.widget.photoMemoCommentList;
  }

  void cancelDelete() {
    state.render(() {
      delIndexes.clear();
    });
  }

  void delete() async {
    MyDialog.circularProgressStart(state.context);
    delIndexes.sort(); // ascending order
    for (int i = delIndexes.length - 1; i >= 0; i--) {
      try {
        PhotoMemo p = photoMemoList[delIndexes[i]];
        await FirestoreController.deletePhotoMemo(photoMemo: p);
        await CloudStorageController.deletePhotoFile(photoMemo: p);
        state.render(() {
          photoMemoList.removeAt(delIndexes[i]);
        });
      } catch (e) {
        // display error on terminal
        if (Constant.DEV) print('======== failed to delete photomemo: $e');
        // display error on mobile device screen
        MyDialog.showSnackBar(
          context: state.context,
          message: 'Failed to delete Photomemo: $e',
        );
        break; // quit further processing
      }
    }
    MyDialog.circularProgressStop(state.context);
    state.render(() => delIndexes.clear());
  }

  void onLongPress(int index) {
    state.render(() {
      if (delIndexes.contains(index))
        delIndexes.remove(index);
      else
        delIndexes.add(index);
    });
    print('Index is : $index');
    print('delIndexes count : ${delIndexes.length}');
  }

  void onTap(int index) async {
    if (delIndexes.isNotEmpty) {
      onLongPress(index);
      return;
    }

    MyDialog.circularProgressStart(state.context);
    try {
      // update photomemo "newComment" boolean to false
      Map<String, dynamic> updateInfo = {};
      if (photoMemoList[index].newSharedwithComment) {
        updateInfo[PhotoMemo.NEW_SHAREDWITH_COMMENT] = false;
        photoMemoList[index].newSharedwithComment = false;
      }
      if (photoMemoList[index].newPublicComment) {
        updateInfo[PhotoMemo.NEW_PUBLIC_COMMENT] = false;
        photoMemoList[index].newPublicComment = false;
      }
      if (updateInfo.isNotEmpty) {
        // changes have been made
        photoMemoList[index].timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = photoMemoList[index].timestamp;
        await FirestoreController.updatePhotoMemo(
          docId: photoMemoList[index].docId!,
          updateInfo: updateInfo,
        );
      }

      // collect comments related to ontapped photomemo
      List<PhotoMemoComment> specificPhotoMemoCommentList = [];
      for (var c in photoMemoCommentList) {
        if (c.photoURL == photoMemoList[index].photoURL) {
          specificPhotoMemoCommentList.add(c);
        }
      }

      await Navigator.pushNamed(state.context, DetailedViewScreen.routeName,
          arguments: {
            ARGS.USER: state.widget.user,
            ARGS.OnePhotoMemo: photoMemoList[index],
            ARGS.PhotoMemoCommentList: specificPhotoMemoCommentList,
          });
      MyDialog.circularProgressStop(state.context);
      // re-render home screen
      state.render(() {
        // re-order based on the updated timestamp
        photoMemoList.sort((a, b) {
          if (a.timestamp!.isBefore(b.timestamp!))
            return 1; // descending order
          else if (a.timestamp!.isAfter(b.timestamp!))
            return -1;
          else
            return 0;
        });
      });
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update photomemo error:$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update PhotoMemo error. $e',
      );
    }
  }

  // Below: Drawer functions

  Future<void> signOut() async {
    try {
      await FirebaseAuthController.signOut();
    } catch (e) {
      if (Constant.DEV) print('========= sign out error: $e');
    }
    Navigator.of(state.context).pop(); // close the drawer
    Navigator.of(state.context).pop(); // pop from UserHome
  }

  void navToSettings() async {
    if (Constant.DEV)
      print('========= Future navigation to settings screen. =========');
    await Navigator.pushNamed(state.context, SettingsScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
          ARGS.PhotoMemoList: photoMemoList,
          ARGS.PhotoMemoCommentList: photoMemoCommentList,
        });
    state.render(() {});
    Navigator.of(state.context).pop(); // close the drawer
  }

  // Below: Sort By functions

  void getListMostRecentlyUpdated() async {
    MyDialog.circularProgressStart(state.context);
    try {
      photoMemoList =
          await FirestoreController.getPhotoMemoList(email: state.widget.email);
      state.render(() {});
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('=== sort by most recently updated error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort by most recently updated Error: $e',
        seconds: 10,
      );
    }
  }

  void getListNewestFirst() async {
    MyDialog.circularProgressStart(state.context);
    try {
      photoMemoList = await FirestoreController.getPhotoMemoListChrono(
          email: state.widget.email);
      state.render(() {});
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('=== sort by newest first error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort by newest first Error: $e',
        seconds: 10,
      );
    }
  }

  void getListOldestFirst() async {
    MyDialog.circularProgressStart(state.context);
    try {
      photoMemoList = await FirestoreController.getPhotoMemoListReverseChrono(
          email: state.widget.email);
      state.render(() {});
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('=== sort by oldest first error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort by oldest first Error: $e',
        seconds: 10,
      );
    }
  }

  void getListAlphabetical() async {
    MyDialog.circularProgressStart(state.context);
    try {
      photoMemoList = await FirestoreController.getPhotoMemoListAlphabetical(
          email: state.widget.email);
      state.render(() {});
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('=== sort by alphabetical order error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort by alphabetical order Error: $e',
        seconds: 10,
      );
    }
  }

  void getListReverseAlphabetical() async {
    MyDialog.circularProgressStart(state.context);
    try {
      photoMemoList =
          await FirestoreController.getPhotoMemoListReverseAlphabetical(
              email: state.widget.email);
      state.render(() {});
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV)
        print('=== sort by reverse alphabetical order error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort by reverse alphabetical order Error: $e',
        seconds: 10,
      );
    }
  }

  // Below: Bottom Navigation Bar functions
  void feedButton() async {
    try {
      List<PhotoMemo> completePhotoMemoList =
          await FirestoreController.getAllPhotoMemoList();

      await Navigator.pushNamed(state.context, FeedScreen.routeName,
          arguments: {
            ARGS.PhotoMemoList: completePhotoMemoList,
            ARGS.USER: state.widget.user,
          });
    } catch (e) {
      if (Constant.DEV) print('======== Nav to Feed Screen error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to navigate to Feed Screen: $e',
      );
    }
  }

  void searchButton() async {
    try {
      List<PhotoMemo> completePhotoMemoList =
          await FirestoreController.getAllPhotoMemoList();

      await Navigator.pushNamed(state.context, PublicSearchScreen.routeName,
          arguments: {
            ARGS.PhotoMemoList: completePhotoMemoList,
            ARGS.USER: state.widget.user,
          });
    } catch (e) {
      if (Constant.DEV) print('======== Nav to Public Search Screen error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to navigate to Public Search Screen: $e',
      );
    }
  }

  void addButton() async {
    // navigate to AddNewPhotoMemo
    await Navigator.pushNamed(
      state.context,
      AddNewPhotoMemoScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.PhotoMemoList: photoMemoList,
      },
    );
    state.render(() {}); // re-render the home screen if new photomemo is added
  }

  bool newComments() {
    for (int i = 0; i < photoMemoList.length; i++) {
      if (photoMemoList[i].newSharedwithComment ||
          photoMemoList[i].newPublicComment) return true;
    }
    return false;
  }

  void sharedWith() async {
    try {
      List<PhotoMemo> photoMemoListSharedWith =
          await FirestoreController.getPhotoMemoListSharedWith(
              email: state.widget.email);

      await Navigator.pushNamed(state.context, SharedWithScreen.routeName,
          arguments: {
            ARGS.PhotoMemoList: photoMemoListSharedWith,
            ARGS.USER: state.widget.user,
          });
    } catch (e) {
      if (Constant.DEV) print('======== sharedWith error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get sharedwith list: $e',
      );
    }
  }

  void homeButton() {
    if (Constant.DEV)
      print('========= You are already on the userhome_screen.');
  }
}
