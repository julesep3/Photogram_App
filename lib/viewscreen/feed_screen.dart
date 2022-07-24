import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/addpubliccomment_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = '/feedScreen';
  final List<PhotoMemo> photoMemoList;
  final User user;
  late final String userName;
  late final String profilePicture;
  late final String userEmail;

  FeedScreen({
    required this.photoMemoList,
    required this.user,
  }) {
    userName = user.displayName ?? 'N/A';
    profilePicture = user.photoURL ?? '';
    userEmail = user.email ?? 'N/A';
  }

  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<FeedScreen> {
  final df = DateFormat('MM-dd-yyyy hh:mm a');
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
        backgroundColor: Colors.black,
        title: Text(
          'Photogram',
          style: TextStyle(
            fontFamily: 'GrandHotel',
            fontSize: 27,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: widget.photoMemoList.isEmpty
            ? Text(
                'No Photograms are currently shared.',
              )
            : Column(
                children: [
                  for (int i = 0; i < widget.photoMemoList.length; i++)
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.black,
                          child: Column(
                            children: [
                              // card - top banner
                              Container(
                                width: MediaQuery.of(context).size.width,
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
                                        children: [
                                          Text(
                                            '${widget.photoMemoList[i].createdByUsername}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '${widget.photoMemoList[i].title}',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - photomemo image
                              WebImage(
                                context: context,
                                url: widget.photoMemoList[i].photoURL,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              // card - icons banner under photomemo image
                              Container(
                                color: Colors.black,
                                height: 45,
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Row(
                                        children: [
                                          con.onLikedList(i)
                                              ? Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      12, 0, 0, 0),
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        con.likeButton(i),
                                                    icon: Icon(
                                                      Icons.favorite_rounded,
                                                      size: 28,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      12, 0, 0, 0),
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        con.likeButton(i),
                                                    icon: Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Icon(
                                              Icons.mode_comment_outlined,
                                              size: 28,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                12, 0, 0, 0),
                                            child: Icon(
                                              Icons.near_me_outlined,
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.bookmark_border_sharp,
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - likes and memo banner
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 5),
                                color: Colors.black,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    con.numberOfLikes(
                                                widget.photoMemoList[i]) ==
                                            0
                                        ? Container(
                                            child: Text(
                                              'No likes yet',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Text(
                                              '${con.numberOfLikes(widget.photoMemoList[i])} likes',
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                    Container(
                                      padding: EdgeInsets.only(top: 7),
                                      child: Text(
                                        '${widget.photoMemoList[i].createdByUsername} - ${widget.photoMemoList[i].memo}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - add a comment section
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                color: Colors.black,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        maxRadius: 25,
                                        backgroundColor: Colors.purpleAccent,
                                        backgroundImage:
                                            NetworkImage(widget.profilePicture),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          con.navToCommentScreen(i),
                                      child: Text(
                                        'Add a comment...',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - see comments button
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 48,
                                margin: EdgeInsets.only(left: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          con.navToCommentScreen(i),
                                      child: Text(
                                        'See comments',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // card - bottom timestamp
                              Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        df.format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                widget
                                                    .photoMemoList[i]
                                                    .timestamp!
                                                    .millisecondsSinceEpoch)),
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Controller {
  late _FeedState state;
  late List<PhotoMemo> photoMemoList;
  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }

  // Below: 'Liked' functions

  int numberOfLikes(PhotoMemo p) {
    return p.numberOfLikes;
  }

  void likeButton(int index) {
    state.render(() {
      if (onLikedList(index))
        removeFromLikedByList(photoMemoList[index]);
      else
        addToLikedByList(photoMemoList[index]);
    });
  }

  void addToLikedByList(PhotoMemo p) async {
    PhotoMemo tempMemo = PhotoMemo.clone(p);
    MyDialog.circularProgressStart(state.context);
    try {
      Map<String, dynamic> updateInfo = {};
      tempMemo.likedBy.add(state.widget.userEmail);
      updateInfo[PhotoMemo.LIKED_BY] = tempMemo.likedBy;
      tempMemo.numberOfLikes++;
      updateInfo[PhotoMemo.NUMBER_OF_LIKES] = tempMemo.numberOfLikes;
      if (updateInfo.isNotEmpty) {
        tempMemo.timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = tempMemo.timestamp;
        await FirestoreController.updatePhotoMemo(
          docId: tempMemo.docId!,
          updateInfo: updateInfo,
        );
        p.assign(tempMemo);
      }
      MyDialog.circularProgressStop(state.context);
      state.render(() {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update likedBy error:$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update likedBy error. $e',
      );
    }
  }

  void removeFromLikedByList(PhotoMemo p) async {
    PhotoMemo tempMemo = PhotoMemo.clone(p);
    MyDialog.circularProgressStart(state.context);
    try {
      Map<String, dynamic> updateInfo = {};
      tempMemo.likedBy.remove(state.widget.userEmail);
      updateInfo[PhotoMemo.LIKED_BY] = tempMemo.likedBy;
      tempMemo.numberOfLikes--;
      updateInfo[PhotoMemo.NUMBER_OF_LIKES] = tempMemo.numberOfLikes;
      if (updateInfo.isNotEmpty) {
        tempMemo.timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = tempMemo.timestamp;
        await FirestoreController.updatePhotoMemo(
          docId: tempMemo.docId!,
          updateInfo: updateInfo,
        );
        p.assign(tempMemo);
      }
      MyDialog.circularProgressStop(state.context);
      state.render(() {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update likedBy error:$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update likedBy error. $e',
      );
    }
  }

  bool onLikedList(int index) {
    List<String> usersLiked = [...photoMemoList[index].likedBy];
    if (usersLiked.contains(state.widget.userEmail)) return true;
    return false;
  }

  void navToCommentScreen(int index) async {
    await Navigator.pushNamed(
      state.context,
      AddPublicCommentScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.OnePhotoMemo: photoMemoList[index],
      },
    );
  }
}
