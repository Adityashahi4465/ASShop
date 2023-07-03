import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      email, password) async {
    final auth = FirebaseAuth.instance;
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      final auth = FirebaseAuth.instance;
      return await auth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> logOut(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (googleSignIn.currentUser != null) {
        await googleSignIn.disconnect();
        await FirebaseAuth.instance.signOut();
        Future.delayed(const Duration(microseconds: 1000)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/welcome_screen');
        });
      } else {
        await FirebaseAuth.instance.signOut().whenComplete(() {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/welcome_screen');
        });
      }
    } catch (e) {
      print('Error Occurred during sign Out $e');
    }
  }

  static Future<void> sendEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> reloadUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.reload();
  }

  static Future<bool> checkEmailVerification() async {
    User user = FirebaseAuth.instance.currentUser!;
    return user.emailVerified;
  }

  static Future<void> updateUserName(displayName) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updateDisplayName(displayName);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateUserProfilePhoto(photoImage) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePhotoURL(photoImage);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    try {
      AuthCredential authCredential =
          EmailAuthProvider.credential(email: email, password: password);
      var credentialResult =
          await currentUser.reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> updatePassword(newPassword) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    try {
      await currentUser.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }

  static get uid {
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
