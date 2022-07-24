import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class PublicDetailedScreen extends StatefulWidget {
  static const routeName = '/publicDetailedScreen';

  final User user;
  final PhotoMemo photoMemo;
  late final String userEmail;
  late final String username;
  late final String profilePicture;

  PublicDetailedScreen({
    required this.user,
    required this.photoMemo,
  }) {
    userEmail = user.email ?? 'no email';
    username = user.displayName ?? 'no username';
    profilePicture = user.photoURL ?? 'no profile pic';
  }

  @override
  State<StatefulWidget> createState() {
    return _PublicDetailedState();
  }
}

class _PublicDetailedState extends State<PublicDetailedScreen> {
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  render(fn) => setState(fn);

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
        child: Column(
          children: [
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 7),
                              child: Text(
                                'Memo - \'${widget.photoMemo.memo}\'',
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
  late _PublicDetailedState state;
  _Controller(this.state);
}
