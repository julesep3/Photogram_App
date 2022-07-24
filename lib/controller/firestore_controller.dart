import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/photomemo_comment.dart';

class FirestoreController {
  // return Future<> value because async/await
  static Future<String> addPhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .add(photoMemo.toFirestoreDoc());
    return ref.id; // doc id (unique id auto generated)
  }

  static Future<String> addPhotoMemoComment({
    required PhotoMemoComment photoMemoComment,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .add(photoMemoComment.toFirestoreDoc());
    return ref.id; // doc id (unique id auto generated)
  }

  // gets user's photomemo list
  static Future<List<PhotoMemo>> getPhotoMemoList({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo list in reverse chronological order
  static Future<List<PhotoMemo>> getPhotoMemoListChrono({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.CREATION_DATE, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo list in reverse chronological order
  static Future<List<PhotoMemo>> getPhotoMemoListReverseChrono({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.CREATION_DATE, descending: false)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo list in alphabetical order
  static Future<List<PhotoMemo>> getPhotoMemoListAlphabetical({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TITLE, descending: false)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo list in reverse alphabetical order
  static Future<List<PhotoMemo>> getPhotoMemoListReverseAlphabetical({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: email)
        .orderBy(PhotoMemo.TITLE, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets all photomemos in a list
  static Future<List<PhotoMemo>> getAllPhotoMemoList() async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemo.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo comments list about the photos they shared
  static Future<List<PhotoMemoComment>> getPhotoMemoCommentList({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .where(PhotoMemoComment.PHOTO_OWNER, isEqualTo: email)
        .orderBy(PhotoMemoComment.TIMESTAMP, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemoComment>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemoComment.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // gets user's photomemo comments list about the photos they commented on
  static Future<List<PhotoMemoComment>> getPhotoMemoCommentMadeList({
    required String email,
  }) async {
    // QuerySnapshot is just container of info (need to convert to list)
    // if query involves more than one field, we need to create a composite index (CREATED_BY, TIMESTAMP)
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .where(PhotoMemoComment.COMMENT_AUTHOR, isEqualTo: email)
        .orderBy(PhotoMemoComment.TIMESTAMP, descending: true)
        .get();
    // convert each doc in querySnapshot and place in result
    var result = <PhotoMemoComment>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = PhotoMemoComment.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) {
          // filter invalid photomemo doc in Firestore
          result.add(p);
        }
      }
    });
    return result;
  }

  // update the photomemo
  static Future<void> updatePhotoMemo({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  // update the photomemo comment
  static Future<void> updateComment({
    required String docId,
    required Map<String, dynamic> updateInfo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  // return Future List of Photomemos (async/await)
  static Future<List<PhotoMemo>> searchImages({
    required String createdBy,
    required List<String> searchLabels, // OR search
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.CREATED_BY, isEqualTo: createdBy)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemo.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (p != null) results.add(p);
    });
    return results;
  }

  // return Future List of Photomemos (async/await)
  static Future<List<PhotoMemo>> searchAllImages({
    required List<String> searchLabels, // OR search
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.IMAGE_LABELS, arrayContainsAny: searchLabels)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemo.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (p != null) results.add(p);
    });
    return results;
  }

  // deletes the photomemo
  static Future<void> deletePhotoMemo({
    required PhotoMemo photoMemo,
  }) async {
    await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .doc(photoMemo.docId)
        .delete();
  }

  // gets a photomemo list from the shared-with list
  static Future<List<PhotoMemo>> getPhotoMemoListSharedWith({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COLLECTION)
        .where(PhotoMemo.SHARED_WITH, arrayContains: email)
        .orderBy(PhotoMemo.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemo>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemo.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (p != null) results.add(p);
    });
    return results;
  }

  // gets a photomemo comments list from the shared-with list
  static Future<List<PhotoMemoComment>> getPhotoMemoCommentListSharedWith({
    required String email,
    required String user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .where(PhotoMemoComment.PHOTO_OWNER, isEqualTo: email)
        .where(PhotoMemoComment.COMMENT_AUTHOR, isEqualTo: user)
        .orderBy(PhotoMemoComment.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemoComment>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemoComment.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (p != null) results.add(p);
    });
    return results;
  }

  // gets a photomemo comments list from the public list
  static Future<List<PhotoMemoComment>> getPhotoMemoCommentListPublic({
    required String email,
    required String photoURL,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.PHOTOMEMO_COMMENT_COLLECTION)
        .where(PhotoMemoComment.PHOTO_OWNER, isEqualTo: email)
        .where(PhotoMemoComment.PHOTO_URL, isEqualTo: photoURL)
        .where(PhotoMemoComment.PUBLIC, isEqualTo: true)
        .orderBy(PhotoMemoComment.TIMESTAMP, descending: true)
        .get();
    var results = <PhotoMemoComment>[];
    querySnapshot.docs.forEach((doc) {
      var p = PhotoMemoComment.fromFirestoreDoc(
          doc: doc.data() as Map<String, dynamic>, docId: doc.id);
      if (p != null) results.add(p);
    });
    return results;
  }
}
