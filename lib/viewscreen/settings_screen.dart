import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settingsScreen';
  final User user;
  late final String email;
  late final String profilePicURL;
  late final String previousPicURL;
  final List<PhotoMemo> photoMemoList;
  final List<PhotoMemoComment> photoMemoCommentList;

  SettingsScreen({
    required this.user,
    required this.photoMemoList,
    required this.photoMemoCommentList,
  }) {
    email = user.email ?? 'no email';
    profilePicURL = user.photoURL ?? '';
    previousPicURL = profilePicURL;
  }

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey1 = GlobalKey();
  GlobalKey<FormState> formKey2 = GlobalKey();
  // photo object represents images from gallery or from camera
  File? photo;

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
        title: Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 35),
                  height: MediaQuery.of(context).size.height * 0.20,
                  // if no loaded photo and no saved profile pic
                  child: photo == null && widget.profilePicURL == ''
                      ? FittedBox(
                          child: CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                          ),
                        )
                      : FittedBox(
                          // if loaded photo and no saved profile pic
                          child: photo != null && widget.profilePicURL == ''
                              ? Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: FileImage(photo!),
                                      backgroundColor: Colors.grey.shade700,
                                    ),
                                  ],
                                )
                              // if loaded photo and no saved profile pic
                              : photo != null && widget.profilePicURL != ''
                                  ? Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: FileImage(photo!),
                                          backgroundColor: Colors.grey.shade700,
                                        ),
                                      ],
                                    )
                                  // if loaded photo and saved profile pic
                                  : Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.profilePicURL),
                                          backgroundColor: Colors.grey.shade700,
                                        ),
                                      ],
                                    ),
                        ),
                ),
                Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    height: 40,
                    width: 40,
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
                          PopupMenuItem(
                            value: source,
                            child: Text('${source.toString().split('.')[1]}'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),
              child: Form(
                key: formKey1,
                child: Column(
                  children: [
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextFormField(
                      initialValue: '${widget.user.displayName}',
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: con.validateUsername,
                      onSaved: con.saveUsername,
                    ),
                    TextFormField(
                      initialValue: '${widget.user.email}',
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: con.validateEmail,
                      onSaved: con.saveEmail,
                    ),
                    ElevatedButton(
                      onPressed: con.saveChanges,
                      child: Text(
                        'Save Changes',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0.0),
              child: Form(
                key: formKey2,
                child: Column(
                  children: [
                    Text(
                      'Password Reset',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: con.validatePassword,
                      onSaved: con.savePassword,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: con.validatePassword,
                      onSaved: con.saveConfirmPassword,
                    ),
                    ElevatedButton(
                      onPressed: con.resetPassword,
                      child: Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 40, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white30,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "Caution: Deletion of user account is permanent.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Press button below if you are sure you want to delete your account.",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: con.deleteAccount,
              child: Text(
                'Delete User Account',
                style: Theme.of(context).textTheme.button,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _SettingsState state;
  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }
  late List<PhotoMemo> photoMemoList;
  String? progressMessage;
  String? email;
  String? username;
  String? password;
  String? passwordConfirm;

  // FormKey1
  void saveChanges() async {
    FormState? currentState = state.formKey1.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      if (username != state.widget.user.displayName) {
        // update user's display name (username)
        await FirebaseAuthController.updateDisplayName(
          displayName: username!,
          user: state.widget.user,
        );

        // update username for each photomemo
        late PhotoMemo tempMemo;
        for (var p in photoMemoList) {
          tempMemo = PhotoMemo.clone(p);
          Map<String, dynamic> updateInfo = {};
          updateInfo[PhotoMemo.CREATED_BY_USERNAME] = username;
          await FirestoreController.updatePhotoMemo(
            docId: tempMemo.docId!,
            updateInfo: updateInfo,
          );
          p.assign(tempMemo);
        }

        // update username for each comment made
        List<PhotoMemoComment> photoMemoCommentMadeList =
            await FirestoreController.getPhotoMemoCommentMadeList(
                email: state.widget.email);
        late PhotoMemoComment tempMemoComment;
        for (var c in photoMemoCommentMadeList) {
          tempMemoComment = PhotoMemoComment.clone(c);
          Map<String, dynamic> updateInfo = {};
          updateInfo[PhotoMemoComment.COMMENT_AUTHOR_USERNAME] = username;
          await FirestoreController.updateComment(
            docId: tempMemoComment.docId!,
            updateInfo: updateInfo,
          );
          c.assign(tempMemoComment);
        }
      }
      if (email != state.widget.user.email) {
        // update user's email
        await FirebaseAuthController.updateEmail(
          email: email!,
          user: state.widget.user,
        );
      }

      // upload profile pic to Cloud Storage
      if (state.photo != null) {
        Map photoInfo = await CloudStorageController.uploadPhotoFile(
          photo: state.photo!,
          uid: state.widget.user.uid,
          listener: (progress) {
            state.render(() {
              if (progress == 100)
                progressMessage = null;
              else
                progressMessage = 'Uploading $progress %';
            });
          },
        );

        // if (state.widget.previousPicURL != '') {
        //   // delete old profile pic from cloud storage
        //   PhotoMemo pm = PhotoMemo();
        //   pm.photoURL = state.widget.previousPicURL;
        //   print('======================== Previous Pic URL : ${pm.photoURL}');
        //   await CloudStorageController.deletePhotoFileViaURL(photoMemo: pm);
        // }

        // update user's profile pic URL
        await FirebaseAuthController.updatePhotoURL(
          photoURL: photoInfo[ARGS.DownloadURL],
          user: state.widget.user,
        );

        // update profilePicURL for each photomemo made
        late PhotoMemo tempMemo;
        for (var p in photoMemoList) {
          tempMemo = PhotoMemo.clone(p);
          Map<String, dynamic> updateInfo = {};
          updateInfo[PhotoMemo.CREATED_BY_PHOTO_URL] =
              photoInfo[ARGS.DownloadURL];
          await FirestoreController.updatePhotoMemo(
            docId: tempMemo.docId!,
            updateInfo: updateInfo,
          );
          p.assign(tempMemo);
        }
      }

      MyDialog.showSnackBar(
        context: state.context,
        message: '''User account information updated.
Please log back in to enact changes.''',
      );
      MyDialog.circularProgressStop(state.context);
      signOut();
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('========== update account error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Cannot update account: $e',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuthController.signOut();
    } catch (e) {
      if (Constant.DEV) print('========= sign out error: $e');
    }
    // Navigator.of(state.context).pop(); // pop from Settings
    Navigator.of(state.context).pop(); // close the drawer
    Navigator.of(state.context).pop(); // pop from UserHome
  }

  String? validateUsername(String? value) {
    if (value == null || value.length < 1 || value.length > 16)
      return 'Invalid username';
    else
      return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !(value.contains('.') && value.contains('@')))
      return 'Invalid email address';
    else
      return null;
  }

  void saveEmail(String? value) {
    email = value;
  }

  void saveUsername(String? value) {
    username = value;
  }

  void getPhoto(PhotoSource source) async {
    try {
      var imageSource = source == PhotoSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return; // cancelled by camera or gallery
      state.render(() => state.photo = File(image.path));
      MyDialog.showSnackBar(
        context: state.context,
        message:
            '''Selected profile picture for preview only until you select <Save Changes>''',
      );
    } catch (e) {
      if (Constant.DEV) print('======== failed to get a pic: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get a picture: $e',
      );
    }
  }

  // FormKey2
  void resetPassword() async {
    FormState? currentState = state.formKey2.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (!passwordsMatch()) {
      MyDialog.showSnackBar(
        context: state.context,
        message: '''Passwords do not match.
Please enter new password again.''',
      );
      return;
    }
    try {
      await FirebaseAuthController.updatePassword(
        password: password!,
        user: state.widget.user,
      );

      MyDialog.showSnackBar(
        context: state.context,
        message: '''Password is updated!
Sign back in to enact changes.''',
      );
      signOut();
    } catch (e) {
      if (Constant.DEV) print('========== update password error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Cannot update password: $e',
      );
    }
  }

  bool passwordsMatch() {
    if (password == passwordConfirm) return true;
    return false;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6)
      return 'password too short';
    else
      return null;
  }

  void savePassword(String? value) {
    password = value;
  }

  void saveConfirmPassword(String? value) {
    passwordConfirm = value;
  }

  void deleteAccount() {
    try {
      FirebaseAuthController.delete(
        user: state.widget.user,
      );
      MyDialog.showSnackBar(
        context: state.context,
        message: '''Your account has been permanently deleted.
Thank you for using PhotoGram!''',
      );
    } catch (e) {
      if (Constant.DEV) print('========== delete account error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Cannot delete account: $e',
      );
    }
    // Navigator.of(state.context).pop(); // pop from Settings
    Navigator.of(state.context).pop(); // close the drawer
    Navigator.of(state.context).pop(); // pop from UserHome
  }
}
