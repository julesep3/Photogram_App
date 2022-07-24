import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/controller/googleML_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class AddNewPhotoMemoScreen extends StatefulWidget {
  static const routeName = '/addNewPhotoMemoScreen';
  late final User user;
  late final String username;
  late final String profilePicURL;
  final List<PhotoMemo> photoMemoList;

  AddNewPhotoMemoScreen({
    required this.user,
    required this.photoMemoList,
  }) {
    username = user.displayName ?? 'N/A';
    profilePicURL = user.photoURL ?? 'N/A';
  }

  @override
  State<StatefulWidget> createState() {
    return _AddNewPhotoMemoState();
  }
}

class _AddNewPhotoMemoState extends State<AddNewPhotoMemoScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();
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
        backgroundColor: Colors.black,
        title: Text('Add New PhotoMemo'),
        actions: [
          IconButton(
            onPressed: con.save,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // photomemo image
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: photo == null
                            ? FittedBox(
                                child: Icon(
                                  Icons.photo_library,
                                ),
                              )
                            : Image.file(photo!),
                      ),
                      Positioned(
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
                                PopupMenuItem(
                                  value: source,
                                  child: Text(
                                      '${source.toString().split('.')[1]}'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // show progress listener from con.save()
                  con.progressMessage == null
                      ? SizedBox(
                          height: 1.0,
                        )
                      : Text(
                          con.progressMessage!,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                    autocorrect: true,
                    validator: PhotoMemo.validateTitle,
                    onSaved: con.saveTitle,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Memo',
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    validator: PhotoMemo.validateMemo,
                    onSaved: con.saveMemo,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Shared with (comma separated email list)',
                    ),
                    maxLines: 2,
                    keyboardType: TextInputType.emailAddress,
                    validator: PhotoMemo.validateSharedWith,
                    onSaved: con.saveSharedWith,
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
  late _AddNewPhotoMemoState state;
  PhotoMemo tempMemo = PhotoMemo();
  String? progressMessage;
  _Controller(this.state);

  void save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    // photo upload
    if (state.photo == null) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Photo not selected',
      );
      return;
    }
    MyDialog.circularProgressStart(state.context);
    try {
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
      // get image labels by ML
      List<String> recognitions =
          await GoogleMLController.getImageLabels(photo: state.photo!);
      tempMemo.imageLabels.addAll(recognitions);

      // set tempMemo to addPhotoMemo to Firestore
      tempMemo.photoFilename = photoInfo[ARGS.Filename];
      tempMemo.photoURL = photoInfo[ARGS.DownloadURL];
      tempMemo.createdBy = state.widget.user.email!;
      tempMemo.createdByUsername = state.widget.username;
      tempMemo.createdByPhotoURL = state.widget.profilePicURL;
      tempMemo.timestamp = DateTime.now();
      tempMemo.creationDate = DateTime.now();
      String docId =
          await FirestoreController.addPhotoMemo(photoMemo: tempMemo);
      tempMemo.docId = docId;
      // insert tempMemo into photoMemoList at top of list (index 0)
      state.widget.photoMemoList.insert(0, tempMemo);
      MyDialog.circularProgressStop(state.context);
      // return to UserHome screen
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('======== Add new photomemo failed: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Add new photomemo failed: $e',
      );
    }
  }

  void getPhoto(PhotoSource source) async {
    try {
      var imageSource = source == PhotoSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return; // cancelled by camera or gallery
      state.render(() => state.photo = File(image.path));
    } catch (e) {
      if (Constant.DEV) print('======== failed to get a pic: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get a picture: $e',
      );
    }
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
