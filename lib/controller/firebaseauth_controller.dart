import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController {
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> updateDisplayName({
    required String displayName,
    required User user,
  }) {
    return user.updateDisplayName(displayName);
  }

  static Future<void> updateEmail({
    required String email,
    required User user,
  }) async {
    await user.updateEmail(email);
  }

  static Future<void> updatePassword({
    required String password,
    required User user,
  }) async {
    user.updatePassword(password);
  }

  static Future<void> updatePhotoURL({
    required String photoURL,
    required User user,
  }) {
    return user.updatePhotoURL(photoURL);
  }

  static Future<void> delete({
    required User user,
  }) async {
    return user.delete();
  }
}
