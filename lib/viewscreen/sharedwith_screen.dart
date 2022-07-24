import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/sharedwith_detailedview_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';
  final List<PhotoMemo> photoMemoList; // shared with me photoMemoList
  final User user;
  late final String email;
  late final String username;
  late final String profilePic;

  SharedWithScreen({
    required this.photoMemoList,
    required this.user,
  }) {
    email = user.email ?? 'no email';
    username = user.displayName ?? 'no username';
    profilePic = user.photoURL ?? 'no profile picture';
  }
  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Photomemos Shared With You',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: widget.photoMemoList.isEmpty
            ? Text(
                'No PhotoMemos shared with me',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: [
                  for (int i = 0; i < widget.photoMemoList.length; i++)
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: Colors.white30,
                              width: 1,
                            ),
                          ),
                          color: Colors.black,
                          child: Column(
                            children: [
                              // card - top banner
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                height: 58.0,
                                color: Colors.black,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      child: CircleAvatar(
                                        maxRadius: 25,
                                        backgroundColor: Colors.purpleAccent,
                                        backgroundImage: NetworkImage(widget
                                            .photoMemoList[i]
                                            .createdByPhotoURL),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(7.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${widget.photoMemoList[i].createdByUsername}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${widget.photoMemoList[i].title}',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - photomemo image
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width,
                                child: IconButton(
                                  icon: WebImage(
                                    url: widget.photoMemoList[i].photoURL,
                                    context: context,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                  ),
                                  iconSize:
                                      MediaQuery.of(context).size.height * 0.20,
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () =>
                                      con.navigateToSharedWithDetailed(i),
                                ),
                              ),
                              // card - photomemo memo
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 7),
                                      child: Center(
                                        child: Text(
                                          '\'${widget.photoMemoList[i].memo}\'',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - divider
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Divider(
                                  color: Colors.white24,
                                ),
                              ),
                              // card - user profile pic with comments
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 4.0,
                                      ),
                                      child: Text('Your Comments (below):'),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 2, 9, 10),
                                          width: 40,
                                          child: CircleAvatar(
                                            maxRadius: 20,
                                            backgroundColor:
                                                Colors.purpleAccent,
                                            backgroundImage:
                                                NetworkImage(widget.profilePic),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      con.sharedWithPhotoMemoCommentList
                                                          .length;
                                                  j++)
                                                widget.photoMemoList[i]
                                                            .photoURL ==
                                                        con
                                                            .sharedWithPhotoMemoCommentList[
                                                                j]
                                                            .photoURL
                                                    ? Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: Text(
                                                          ' -> \"${con.sharedWithPhotoMemoCommentList[j].comment}\"',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 0.0,
                                                      ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}

class _Controller {
  late _SharedWithState state;
  late List<PhotoMemo> photoMemoList;
  List<String> photoMemoOwnersList = [];
  List<PhotoMemoComment> sharedWithPhotoMemoCommentList = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
    updateCommentsList();
  }

  void updateCommentsList() {
    state.render(() {
      getPhotoMemoOwners();
      getSharedWithComments();
    });
  }

  void getPhotoMemoOwners() {
    photoMemoOwnersList.clear();
    for (var p in photoMemoList)
      if (!photoMemoOwnersList.contains(p.createdBy)) {
        photoMemoOwnersList.add(p.createdBy);
      }
  }

  void getSharedWithComments() async {
    List<PhotoMemoComment> commentList = [];
    sharedWithPhotoMemoCommentList.clear();
    try {
      for (var owner in photoMemoOwnersList) {
        commentList =
            await FirestoreController.getPhotoMemoCommentListSharedWith(
                email: owner, user: state.widget.email);
        for (var comment in commentList) {
          sharedWithPhotoMemoCommentList.add(comment);
        }
      }
    } catch (e) {
      if (Constant.DEV)
        print('======== sharedWith photomemo comment list error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get sharedwith photomemo comment list: $e',
      );
    }

    state.render(() {});
  }

  void navigateToSharedWithDetailed(int index) async {
    await Navigator.pushNamed(
      state.context,
      SharedWithDetailedViewScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.OnePhotoMemo: photoMemoList[index],
      },
    );
    updateCommentsList();
  }
}
