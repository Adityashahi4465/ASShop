import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    try {
      await auth.signOut().whenComplete(
        () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/welcome_screen');
        },
      );
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

  static get uid {
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
