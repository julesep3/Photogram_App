import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class AddPublicCommentScreen extends StatefulWidget {
  static const routeName = '/addPublicCommentScreen';

  final User user;
  final PhotoMemo photoMemo;
  late final String photoMemoOwner;
  late final String photoMemoURL;
  late final String userProfilePicURL;

  AddPublicCommentScreen({
    required this.user,
    required this.photoMemo,
  }) {
    photoMemoOwner = photoMemo.createdBy;
    photoMemoURL = photoMemo.photoURL;
    userProfilePicURL = user.photoURL ?? 'no profile pic url';
  }

  @override
  State<StatefulWidget> createState() {
    return _AddPublicCommentState();
  }
}

class _AddPublicCommentState extends State<AddPublicCommentScreen> {
  final df = DateFormat('MM-dd-yyyy hh:mm a');
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
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
                              backgroundImage: NetworkImage(
                                  widget.photoMemo.createdByPhotoURL),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(7.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.photoMemo.createdByUsername}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${widget.photoMemo.title}',
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
                      url: widget.photoMemo.photoURL,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    // card - likes and memo banner
                    Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 5),
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          '${widget.photoMemo.createdByUsername} - ${widget.photoMemo.memo}',
                        ),
                      ),
                    ),
                    // card - add a comment section
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      height: 60,
                      color: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              maxRadius: 25,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage:
                                  NetworkImage(widget.user.photoURL!),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                              ),
                              maxLines: 4,
                              autocorrect: true,
                              validator: PhotoMemoComment.validateComment,
                              onSaved: con.saveComment,
                            ),
                          ),
                          TextButton(
                            onPressed: con.addPublicComment,
                            child: Text(
                              'Post',
                              style: TextStyle(
                                fontSize: 13,
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
                    // card - previous comments section
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: con.commentList.isEmpty
                          ? Text('No comments yet...')
                          : Column(
                              children: [
                                for (int i = 0; i < con.commentList.length; i++)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 2, 9, 10),
                                        width: 40,
                                        child: CircleAvatar(
                                          maxRadius: 14,
                                          backgroundColor: Colors.purpleAccent,
                                          backgroundImage: NetworkImage(con
                                              .commentList[i]
                                              .commentAuthorProfilePicURL),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${con.commentList[i].comment}',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            df.format(DateTime
                                                .fromMillisecondsSinceEpoch(con
                                                    .commentList[i]
                                                    .timestamp!
                                                    .microsecondsSinceEpoch)),
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
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
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _AddPublicCommentState state;
  late PhotoMemo tempMemo;
  _Controller(this.state) {
    tempMemo = PhotoMemo.clone(state.widget.photoMemo);
    getPublicComments();
  }
  List<PhotoMemoComment> commentList = [];
  PhotoMemoComment tempMemoComment = PhotoMemoComment();

  void addPublicComment() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      // add new photomemo comment
      tempMemoComment.public = true;
      tempMemoComment.commentAuthor = state.widget.user.email!;
      tempMemoComment.commentAuthorProfilePicURL =
          state.widget.userProfilePicURL;
      tempMemoComment.commentAuthorUsername = state.widget.user.displayName!;
      tempMemoComment.timestamp = DateTime.now();
      print(DateTime.now());
      tempMemoComment.photoOwner = state.widget.photoMemo.createdBy;
      tempMemoComment.photoURL = state.widget.photoMemo.photoURL;
      String docId = await FirestoreController.addPhotoMemoComment(
        photoMemoComment: tempMemoComment,
      );
      tempMemoComment.docId = docId;

      // update photoMemo 'newPublicComment' boolean
      Map<String, dynamic> updateInfo = {};
      if (tempMemo.newPublicComment == false) {
        tempMemo.newPublicComment = true;
        updateInfo[PhotoMemo.NEW_PUBLIC_COMMENT] = tempMemo.newPublicComment;
      }
      if (updateInfo.isNotEmpty) {
        // changes have been made
        tempMemo.timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = tempMemo.timestamp;
        await FirestoreController.updatePhotoMemo(
          docId: tempMemo.docId!,
          updateInfo: updateInfo,
        );
        // once all is updated, orig photoMemo is updated
        state.widget.photoMemo.assign(tempMemo);
      }

      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== add public comment error:\n$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Add public comment error. \n$e',
      );
    }
  }

  void getPublicComments() async {
    commentList.clear();
    try {
      commentList = await FirestoreController.getPhotoMemoCommentListPublic(
          email: state.widget.photoMemoOwner,
          photoURL: state.widget.photoMemoURL);
      state.render(() {});
    } catch (e) {
      if (Constant.DEV) print('======== get public comment list error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get public comment list: $e',
      );
    }
  }

  void saveComment(String? value) {
    if (value == null) return;
    if (state.widget.user.email == null) return;
    tempMemoComment.comment = value;
  }
}
