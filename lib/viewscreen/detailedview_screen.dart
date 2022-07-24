import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/controller/googleML_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';

  final User user;
  final PhotoMemo photoMemo;
  final List<PhotoMemoComment> photoMemoCommentList;
  late final String profilePicture;
  late final String username;

  DetailedViewScreen(
      {required this.user,
      required this.photoMemo,
      required this.photoMemoCommentList}) {
    profilePicture = user.photoURL ?? '';
    username = user.displayName ?? '';
  }

  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  final df = DateFormat('MM-dd-yyyy hh:mm a');
  late _Controller con;
  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? progressMessage;

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
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 18,
              child: CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(widget.profilePicture),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 9,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.photoMemo.title,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          editMode
              ? IconButton(onPressed: con.update, icon: Icon(Icons.check))
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        child: con.photo == null
                            ? WebImage(
                                url: con.tempMemo.photoURL,
                                context: context,
                              )
                            : Image.file(con.photo!),
                      ),
                      editMode
                          ? Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                child: PopupMenuButton(
                                  onSelected: con.getPhoto,
                                  itemBuilder: (context) => [
                                    for (var source in PhotoSource.values)
                                      PopupMenuItem<PhotoSource>(
                                        value: source,
                                        child: Text(
                                            '${source.toString().split('.')[1]}'),
                                      )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 1.0,
                            ),
                    ],
                  ),
                  progressMessage == null
                      ? SizedBox(
                          height: 1.0,
                        )
                      : Text(
                          progressMessage!,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                  // Title Section
                  TextFormField(
                    enabled: editMode,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.title_rounded),
                      hintText: 'Enter title',
                    ),
                    initialValue: con.tempMemo.title,
                    autocorrect: true,
                    validator: PhotoMemo.validateTitle,
                    onSaved: con.saveTitle,
                  ),
                  // Memo Section
                  TextFormField(
                    enabled: editMode,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.sticky_note_2_outlined),
                      hintText: 'Enter memo',
                    ),
                    initialValue: con.tempMemo.memo,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    autocorrect: true,
                    validator: PhotoMemo.validateMemo,
                    onSaved: con.saveMemo,
                  ),
                  // Shared With Section
                  TextFormField(
                    enabled: editMode,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.share_outlined),
                      hintText: 'Enter sharedWith email list',
                    ),
                    initialValue: con.tempMemo.sharedWith.join(','),
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    autocorrect: false,
                    validator: PhotoMemo.validateSharedWith,
                    onSaved: con.saveSharedWith,
                  ),
                  // Private Comments Section
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Private Comments',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        // Comments Section
                        widget.photoMemoCommentList.isEmpty
                            ? Text(
                                'No private comments yet...',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(7),
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < widget.photoMemoCommentList.length;
                                        i++)
                                      if (!widget
                                          .photoMemoCommentList[i].public)
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 0, 0),
                                          child: Row(
                                            children: [
                                              Text('-  '),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                maxRadius: 13,
                                                child: CircleAvatar(
                                                  maxRadius: 12,
                                                  backgroundColor:
                                                      Colors.purpleAccent,
                                                  backgroundImage: NetworkImage(
                                                      widget
                                                          .photoMemoCommentList[
                                                              i]
                                                          .commentAuthorProfilePicURL),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${widget.photoMemoCommentList[i].commentAuthorUsername} -> \"${widget.photoMemoCommentList[i].comment}\"',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      df.format(DateTime
                                                          .fromMillisecondsSinceEpoch(widget
                                                              .photoMemoCommentList[
                                                                  i]
                                                              .timestamp!
                                                              .microsecondsSinceEpoch)),
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.white24,
                    ),
                  ),
                  // Public Comments Section
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.question_answer_outlined,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Public Comments',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        // Comments Section
                        widget.photoMemoCommentList.isEmpty
                            ? Text(
                                'No public comments yet...',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(7),
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i < widget.photoMemoCommentList.length;
                                        i++)
                                      if (widget.photoMemoCommentList[i].public)
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 0, 0),
                                          child: Row(
                                            children: [
                                              Text('-  '),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                maxRadius: 13,
                                                child: CircleAvatar(
                                                  maxRadius: 12,
                                                  backgroundColor:
                                                      Colors.purpleAccent,
                                                  backgroundImage: NetworkImage(
                                                      widget
                                                          .photoMemoCommentList[
                                                              i]
                                                          .commentAuthorProfilePicURL),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${widget.photoMemoCommentList[i].commentAuthorUsername} -> \"${widget.photoMemoCommentList[i].comment}\"',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      df.format(DateTime
                                                          .fromMillisecondsSinceEpoch(widget
                                                              .photoMemoCommentList[
                                                                  i]
                                                              .timestamp!
                                                              .microsecondsSinceEpoch)),
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.white24,
                    ),
                  ),
                  // Likes Section
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: widget.photoMemo.numberOfLikes > 0
                                      ? Colors.red
                                      : Colors.white38,
                                ),
                              ),
                              Text(
                                'Likes (${widget.photoMemo.numberOfLikes})',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.white24,
                    ),
                  ),
                  // Creation Date Section
                  Text(
                    'Created On:',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    df.format(DateTime.fromMillisecondsSinceEpoch(
                        widget.photoMemo.creationDate!.millisecondsSinceEpoch)),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                  // Divider
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Divider(
                      color: Colors.white24,
                    ),
                  ),
                  // show labels if in dev mode
                  Constant.DEV
                      ? Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.dashboard_outlined,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  Text(
                                    'Image Labels by ML',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              Text(
                                '${con.tempMemo.imageLabels}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 1.0,
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
  late _DetailedViewState state;
  late PhotoMemo tempMemo;
  File? photo;

  _Controller(this.state) {
    tempMemo = PhotoMemo.clone(state.widget.photoMemo);
  }

  void getPhoto(PhotoSource source) async {
    try {
      var imageSource = source == PhotoSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return; // canceled by camera or gallery
      // update/render photo object reference from image we retrieved
      state.render(() => photo = File(image.path));
    } catch (e) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get a picture: $e',
      );
    }
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      Map<String, dynamic> updateInfo = {};
      if (photo != null) {
        Map photoInfo = await CloudStorageController.uploadPhotoFile(
          photo: photo!,
          uid: state.widget.user.uid,
          filename: tempMemo.photoFilename,
          listener: (int progress) {
            state.render(() {
              state.progressMessage =
                  progress == 100 ? null : 'Uploading: $progress %';
            });
          },
        );
        // generate image labels by ML
        List<String> recognitions =
            await GoogleMLController.getImageLabels(photo: photo!);
        tempMemo.imageLabels = recognitions;

        // tempMemo is holding all new changes
        tempMemo.photoURL = photoInfo[ARGS.DownloadURL];
        // update Firebase doc with new photoURL and imageLabel changes
        updateInfo[PhotoMemo.PHOTO_URL] = tempMemo.photoURL;
        updateInfo[PhotoMemo.IMAGE_LABELS] = tempMemo.imageLabels;
      }
      // update Firestore doc
      if (tempMemo.title != state.widget.photoMemo.title)
        updateInfo[PhotoMemo.TITLE] = tempMemo.title;
      if (tempMemo.memo != state.widget.photoMemo.memo)
        updateInfo[PhotoMemo.MEMO] = tempMemo.memo;
      if (!listEquals(tempMemo.sharedWith, state.widget.photoMemo.sharedWith))
        updateInfo[PhotoMemo.SHARED_WITH] = tempMemo.sharedWith;

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
      state.render(() => state.editMode = false);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update photomemo error:$e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update PhotoMemo error. $e',
      );
    }

    state.render(() => state.editMode = false);
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void saveTitle(String? value) {
    if (value != null) tempMemo.title = value;
  }

  void saveMemo(String? value) {
    if (value != null) tempMemo.memo = value;
  }

  void saveSharedWith(String? value) {
    if (value != null && value.trim().length != 0) {
      tempMemo.sharedWith.clear();
      tempMemo.sharedWith.addAll(value.trim().split(RegExp('(,| )+')));
    }
  }
}
