import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<void>sendEmailVerification(email, password) async {
    final auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

}
