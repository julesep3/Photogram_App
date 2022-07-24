class PhotoMemoComment {
  // keys for Firestore doc
  static const COMMENT = 'comment';
  static const COMMENT_AUTHOR = 'commentauthor';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_OWNER = 'photoowner';
  static const TIMESTAMP = 'timestamp';
  static const PUBLIC = 'public';
  static const COMMENT_AUTHOR_USERNAME = 'commentauthorusername';
  static const COMMENT_AUTHOR_PROFILEPICURL = 'commentauthorprofilepicurl';

  // for PhotoMemoComment class
  String? docId;
  late String comment;
  late String commentAuthor;
  late String photoURL;
  late String photoOwner;
  DateTime? timestamp;
  late bool public;
  late String commentAuthorUsername;
  late String commentAuthorProfilePicURL;

  PhotoMemoComment({
    this.docId,
    this.comment = '',
    this.commentAuthor = '',
    this.photoURL = '',
    this.photoOwner = '',
    this.timestamp,
    this.public = false,
    this.commentAuthorUsername = '',
    this.commentAuthorProfilePicURL = '',
  });

  PhotoMemoComment.clone(PhotoMemoComment pc) {
    this.docId = pc.docId;
    this.comment = pc.comment;
    this.commentAuthor = pc.commentAuthor;
    this.photoURL = pc.photoURL;
    this.photoOwner = pc.photoOwner;
    this.timestamp = pc.timestamp;
    this.public = pc.public;
    this.commentAuthorUsername = pc.commentAuthorUsername;
    this.commentAuthorProfilePicURL = pc.commentAuthorProfilePicURL;
  }

  void assign(PhotoMemoComment pc) {
    this.docId = pc.docId;
    this.comment = pc.comment;
    this.commentAuthor = pc.commentAuthor;
    this.photoURL = pc.photoURL;
    this.photoOwner = pc.photoOwner;
    this.timestamp = pc.timestamp;
    this.public = pc.public;
    this.commentAuthorUsername = pc.commentAuthorUsername;
    this.commentAuthorProfilePicURL = pc.commentAuthorProfilePicURL;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      COMMENT: this.comment,
      COMMENT_AUTHOR: this.commentAuthor,
      PHOTO_URL: this.photoURL,
      PHOTO_OWNER: this.photoOwner,
      TIMESTAMP: this.timestamp,
      PUBLIC: this.public,
      COMMENT_AUTHOR_USERNAME: this.commentAuthorUsername,
      COMMENT_AUTHOR_PROFILEPICURL: this.commentAuthorProfilePicURL,
    };
  }

  static PhotoMemoComment? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    // validate each key
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return PhotoMemoComment(
      docId: docId,
      comment: doc[COMMENT] ??= 'N/A',
      commentAuthor: doc[COMMENT_AUTHOR] ??= 'N/A',
      photoURL: doc[PHOTO_URL] ??= 'N/A',
      photoOwner: doc[PHOTO_OWNER] ??= 'N/A',
      timestamp: doc[TIMESTAMP] != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch)
          : DateTime.now(),
      public: doc[PUBLIC] ??= false,
      commentAuthorUsername: doc[COMMENT_AUTHOR_USERNAME] ??= 'N/A',
      commentAuthorProfilePicURL: doc[COMMENT_AUTHOR_PROFILEPICURL] ??= 'N/A',
    );
  }

  static String? validateComment(String? value) {
    return value == null || value.trim().length < 3
        ? 'Comment too short'
        : null;
  }
}
