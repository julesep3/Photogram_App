import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/publicdetailed_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class PublicSearchScreen extends StatefulWidget {
  static const routeName = '/publicSearchScreen';
  final User user;
  final List<PhotoMemo> publicPhotoMemoList;
  late final String email;

  PublicSearchScreen({
    required this.user,
    required this.publicPhotoMemoList,
  }) {
    email = user.email ?? 'no email';
  }

  @override
  State<StatefulWidget> createState() {
    return _PublicSearchState();
  }
}

class _PublicSearchState extends State<PublicSearchScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Form(
            key: formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      constraints: BoxConstraints(),
                      border: InputBorder.none,
                      hintText: 'Search',
                      fillColor: Theme.of(context).backgroundColor,
                      filled: true,
                    ),
                    autocorrect: true,
                    onSaved: con.saveSearchKey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(onPressed: con.search, icon: Icon(Icons.search)),
        ],
      ),
      body: con.photoMemoList.isEmpty
          ? Text(
              'No PhotoMemo found!',
              style: Theme.of(context).textTheme.headline6,
            )
          : SingleChildScrollView(
              child: Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: con.photoMemoList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          onPressed: () => con.navToPublicDetailedScreen(index),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class _Controller {
  late _PublicSearchState state;
  late List<PhotoMemo> photoMemoList;
  String? searchKeyString;

  _Controller(this.state) {
    photoMemoList = state.widget.publicPhotoMemoList;
  }

  void saveSearchKey(String? value) {
    searchKeyString = value;
  }

  void search() async {
    // save current state of form
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    currentState.save();

    List<String> keys = [];
    if (searchKeyString != null) {
      // gets list of 'tokens' from search string separated by , or ' '
      var tokens = searchKeyString!.split(RegExp('(,| )+')).toList();
      for (var t in tokens) {
        if (t.trim().isNotEmpty) keys.add(t.trim().toLowerCase());
      }
    }

    MyDialog.circularProgressStart(state.context);

    try {
      late List<PhotoMemo> results;
      // if search box is empty
      if (keys.isEmpty) {
        // read all photomemos
        results = await FirestoreController.getAllPhotoMemoList();
      } else {
        // search all images in FireStore using searchLabel keys
        results = await FirestoreController.searchAllImages(
          searchLabels: keys,
        );
      }
      MyDialog.circularProgressStop(state.context);
      state.render(() => photoMemoList = results);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('========= search error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Search error: $e',
      );
    }
  }

  void navToPublicDetailedScreen(int index) async {
    await Navigator.pushNamed(
      state.context,
      PublicDetailedScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.OnePhotoMemo: photoMemoList[index],
      },
    );
  }
}
