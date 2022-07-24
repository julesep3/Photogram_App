enum PhotoSource {
  CAMERA,
  GALLERY,
}

class PhotoMemo {
  // keys for Firestore doc
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'createdby';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_FILENAME = 'photofilename';
  static const TIMESTAMP = 'timestamp';
  static const CREATION_DATE = 'creationdate';
  static const SHARED_WITH = 'sharedwith';
  static const IMAGE_LABELS = 'imagelabels';
  static const NEW_SHAREDWITH_COMMENT = 'newsharedwithcomment';
  static const NEW_PUBLIC_COMMENT = 'newpubliccomment';
  static const CREATED_BY_USERNAME = 'createdbyusername';
  static const CREATED_BY_PHOTO_URL = 'createdbyphotoURL';
  static const LIKED_BY = 'likedby';
  static const NUMBER_OF_LIKES = 'numberOfLikes';

  // for PhotoMemo class
  String? docId; // Firestore auto generated doc id
  late String createdBy; // email == user id
  late String title;
  late String memo;
  late String photoFilename; // image at Cloud Storage
  late String photoURL;
  DateTime? timestamp;
  DateTime? creationDate;
  late List<dynamic> sharedWith; // list of emails
  late List<dynamic> imageLabels; // MachineLearning image labels
  late bool newSharedwithComment;
  late bool newPublicComment;
  late String createdByUsername;
  late String createdByPhotoURL; // profile pic of creator
  late int numberOfLikes;
  late List<dynamic> likedBy; // list of users who liked the photogram

  PhotoMemo({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.memo = '',
    this.photoFilename = '',
    this.photoURL = '',
    this.timestamp,
    this.creationDate,
    List<dynamic>? sharedWith,
    List<dynamic>? imageLabels,
    this.newSharedwithComment = false,
    this.newPublicComment = false,
    this.createdByUsername = '',
    this.createdByPhotoURL = '',
    this.numberOfLikes = 0,
    List<dynamic>? likedBy,
  }) {
    this.sharedWith = sharedWith == null ? [] : [...sharedWith];
    this.imageLabels = imageLabels == null ? [] : [...imageLabels];
    this.likedBy = likedBy == null ? [] : [...likedBy];
  }

  PhotoMemo.clone(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.title = p.title;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.creationDate = p.creationDate;
    this.sharedWith = [...p.sharedWith];
    this.imageLabels = [...p.imageLabels];
    this.newSharedwithComment = p.newSharedwithComment;
    this.newPublicComment = p.newPublicComment;
    this.createdByUsername = p.createdByUsername;
    this.createdByPhotoURL = p.createdByPhotoURL;
    this.numberOfLikes = p.numberOfLikes;
    this.likedBy = [...p.likedBy];
  }

  // a.assign(b) ====> a = b
  void assign(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.title = p.title;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.creationDate = p.creationDate;
    this.sharedWith.clear();
    this.sharedWith.addAll(p.sharedWith);
    this.imageLabels.clear();
    this.imageLabels.addAll(p.imageLabels);
    this.newSharedwithComment = p.newSharedwithComment;
    this.newPublicComment = p.newPublicComment;
    this.createdByUsername = p.createdByUsername;
    this.createdByPhotoURL = p.createdByPhotoURL;
    this.numberOfLikes = p.numberOfLikes;
    this.likedBy.clear();
    this.likedBy.addAll(p.likedBy);
  }

  // convert to Firestore compatible data type (map)
  Map<String, dynamic> toFirestoreDoc() {
    return {
      TITLE: this.title,
      CREATED_BY: this.createdBy,
      MEMO: this.memo,
      PHOTO_FILENAME: this.photoFilename,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      CREATION_DATE: this.creationDate,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLabels,
      NEW_SHAREDWITH_COMMENT: this.newSharedwithComment,
      NEW_PUBLIC_COMMENT: this.newPublicComment,
      CREATED_BY_USERNAME: this.createdByUsername,
      CREATED_BY_PHOTO_URL: this.createdByPhotoURL,
      NUMBER_OF_LIKES: this.numberOfLikes,
      LIKED_BY: this.likedBy,
    };
  }

  static PhotoMemo? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    // validate each key
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY] ??= 'N/A',
      title: doc[TITLE] ??= 'N/A',
      memo: doc[MEMO] ??= 'N/A',
      photoFilename: doc[PHOTO_FILENAME] ??= 'N/A',
      photoURL: doc[PHOTO_URL] ??= 'N/A',
      sharedWith: doc[SHARED_WITH] ??= [],
      imageLabels: doc[IMAGE_LABELS] ??= [],
      newSharedwithComment: doc[NEW_SHAREDWITH_COMMENT] ??= false,
      newPublicComment: doc[NEW_PUBLIC_COMMENT] ??= false,
      createdByUsername: doc[CREATED_BY_USERNAME] ??= 'N/A',
      createdByPhotoURL: doc[CREATED_BY_PHOTO_URL] ??= 'N/A',
      numberOfLikes: doc[NUMBER_OF_LIKES] ??= 0,
      likedBy: doc[LIKED_BY] ??= [],
      timestamp: doc[TIMESTAMP] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch)
          : DateTime.now(),
      creationDate: doc[CREATION_DATE] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[CREATION_DATE].millisecondsSinceEpoch)
          : DateTime.now(),
    );
  }

  static String? validateTitle(String? value) {
    return value == null || value.trim().length < 3 ? 'Title too short' : null;
  }

  static String? validateMemo(String? value) {
    return value == null || value.trim().length < 5 ? 'Memo too short' : null;
  }

  static String? validateComment(String? value) {
    return value == null || value.trim().length < 3
        ? 'Comment too short'
        : null;
  }

  static String? validateSharedWith(String? value) {
    if (value == null || value.trim().length == 0) return null;

    // returns list from splitting 'value' by comma or space, trimming outer spaces, adding to list
    // followed by validation of the list
    List<String> emailList =
        value.trim().split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String e in emailList) {
      if (e.contains('@') && e.contains('.'))
        continue;
      else
        return 'Invalid email list: comma or space separated list';
    }
  }
}
