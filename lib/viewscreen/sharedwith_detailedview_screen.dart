import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class SharedWithDetailedViewScreen extends StatefulWidget {
  static const routeName = '/sharedWithDetailedViewScreen';

  final User user;
  final PhotoMemo photoMemo;
  late final String email;
  late final String username;
  late final String photoOwner;
  late final String userProfilePicURL;

  SharedWithDetailedViewScreen({
    required this.user,
    required this.photoMemo,
  }) {
    email = user.email ?? 'no email';
    username = user.displayName ?? 'no username';
    photoOwner = photoMemo.createdByUsername;
    userProfilePicURL = user.photoURL ?? 'no profile pic';
  }

  @override
  State<StatefulWidget> createState() {
    return _SharedWithDetailedViewState();
  }
}

class _SharedWithDetailedViewState extends State<SharedWithDetailedViewScreen> {
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
          'Leave a comment on ${widget.photoOwner}\'s post!',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
            child: Container(
              child: Column(
                children: [
                  // card - top banner
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${widget.photoMemo.createdByUsername}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.photoMemo.title}',
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
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width,
                    child: WebImage(
                      url: widget.photoMemo.photoURL,
                      context: context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
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
                              '\'${widget.photoMemo.memo}\'',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // card - comment box
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white30,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            hintText: 'Enter Comment',
                          ),
                          maxLines: 4,
                          autocorrect: true,
                          validator: PhotoMemoComment.validateComment,
                          onSaved: con.saveComment,
                        ),
                        ElevatedButton(
                          onPressed: con.addComment,
                          child: Text('Save Comment'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent)),
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
    );
  }
}

class _Controller {
  late _SharedWithDetailedViewState state;
  late PhotoMemo tempMemo;
  PhotoMemoComment tempMemoComment = PhotoMemoComment();
  _Controller(this.state) {
    tempMemo = PhotoMemo.clone(state.widget.photoMemo);
  }

  void addComment() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      // add new photomemo comment
      tempMemoComment.commentAuthor = state.widget.user.email!;
      tempMemoComment.commentAuthorProfilePicURL =
          state.widget.userProfilePicURL;
      tempMemoComment.commentAuthorUsername = state.widget.user.displayName!;
      tempMemoComment.timestamp = DateTime.now();
      tempMemoComment.photoOwner = tempMemo.createdBy;
      tempMemoComment.photoURL = tempMemo.photoURL;
      String docId = await FirestoreController.addPhotoMemoComment(
        photoMemoComment: tempMemoComment,
      );
      tempMemoComment.docId = docId;

      // update photoMemo 'newSharedWithComment' boolean
      Map<String, dynamic> updateInfo = {};
      if (tempMemo.newSharedwithComment == false) {
        tempMemo.newSharedwithComment = true;
        updateInfo[PhotoMemo.NEW_SHAREDWITH_COMMENT] =
            tempMemo.newSharedwithComment;
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
      if (Constant.DEV) print('====== add comment error:\n$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Add photomemo comment error. \n$e',
      );
    }
  }

  void saveComment(String? value) {
    if (value == null) return;
    if (state.widget.user.email == null) return;
    tempMemoComment.comment = value;
  }
}
